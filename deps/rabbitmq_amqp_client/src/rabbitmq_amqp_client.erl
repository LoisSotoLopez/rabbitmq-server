%% This Source Code Form is subject to the terms of the Mozilla Public
%% License, v. 2.0. If a copy of the MPL was not distributed with this
%% file, You can obtain one at https://mozilla.org/MPL/2.0/.
%%
%% Copyright (c) 2007-2024 Broadcom. All Rights Reserved. The term “Broadcom” refers to Broadcom Inc. and/or its subsidiaries. All rights reserved.

-module(rabbitmq_amqp_client).

-feature(maybe_expr, enable).

-export[attach_management_link_pair_sync/2,
        declare_queue/2,
        declare_exchange/2,
        bind_queue/5,
        bind_exchange/5,
        unbind_queue/5,
        unbind_exchange/5,
        purge_queue/2,
        delete_queue/2,
        delete_exchange/2
       ].

-define(TIMEOUT, 15_000).
-define(MANAGEMENT_NODE_ADDRESS, <<"$management">>).

-record(link_pair, {outgoing_link :: amqp10_client:link_ref(),
                    incoming_link :: amqp10_client:link_ref()}).
-type link_pair() :: #link_pair{}.

-type x_args() :: #{binary() => {atom(), term()}}.

-type queue_properties() :: #{name => binary(),
                              durable => boolean(),
                              exclusive => boolean(),
                              auto_delete => boolean(),
                              arguments => x_args()}.

-type exchange_properties() :: #{name := binary(),
                                 type => binary(),
                                 durable => boolean(),
                                 auto_delete => boolean(),
                                 internal => boolean(),
                                 arguments => x_args()}.

-type amqp10_prim() :: amqp10_binary_generator:amqp10_prim().

-export_type([link_pair/0]).

-spec attach_management_link_pair_sync(pid(), binary()) ->
    {ok, link_pair()} | {error, term()}.
attach_management_link_pair_sync(Session, Name) ->
    Terminus = #{address => ?MANAGEMENT_NODE_ADDRESS,
                 durable => none},
    OutgoingAttachArgs = #{name => Name,
                           role => {sender, Terminus},
                           snd_settle_mode => settled,
                           rcv_settle_mode => first,
                           properties => #{<<"paired">> => true}},
    IncomingAttachArgs = OutgoingAttachArgs#{role := {receiver, Terminus, self()},
                                             filter => #{}},
    maybe
        {ok, OutgoingRef} ?= attach(Session, OutgoingAttachArgs),
        {ok, IncomingRef} ?= attach(Session, IncomingAttachArgs),
        ok ?= await_attached(OutgoingRef),
        ok ?= await_attached(IncomingRef),
        {ok, #link_pair{outgoing_link = OutgoingRef,
                        incoming_link = IncomingRef}}
    end.

-spec attach(pid(), amqp10_client:attach_args()) ->
    {ok, amqp10_client:link_ref()} | {error, term()}.
attach(Session, AttachArgs) ->
    try amqp10_client:attach_link(Session, AttachArgs)
    catch exit:Reason ->
              {error, Reason}
    end.

-spec await_attached(amqp10_client:link_ref()) ->
    ok | {error, term()}.
await_attached(Ref) ->
    receive
        {amqp10_event, {link, Ref, attached}} ->
            ok;
        {amqp10_event, {link, Ref, {detached, Err}}} ->
            {error, Err}
    after ?TIMEOUT ->
              {error, timeout}
    end.

-spec declare_queue(link_pair(), queue_properties()) ->
    {ok, map()} | {error, term()}.
declare_queue(LinkPair, QueueProperties) ->
    Body0 = maps:fold(
              fun(name, V, Acc) when is_binary(V) ->
                      [{{utf8, <<"name">>}, {utf8, V}} | Acc];
                 (durable, V, Acc) when is_boolean(V) ->
                      [{{utf8, <<"durable">>}, {boolean, V}} | Acc];
                 (exclusive, V, Acc) when is_boolean(V) ->
                      [{{utf8, <<"exclusive">>}, {boolean, V}} | Acc];
                 (auto_delete, V, Acc) when is_boolean(V) ->
                      [{{utf8, <<"auto_delete">>}, {boolean, V}} | Acc];
                 (arguments, V, Acc) ->
                      KVList = maps:fold(
                                 fun(K = <<"x-", _/binary>>, TaggedVal = {T, _}, L)
                                       when is_atom(T) ->
                                         [{{utf8, K}, TaggedVal} | L]
                                 end, [], V),
                      [{{utf8, <<"arguments">>}, {map, KVList}} | Acc]
              end, [{{utf8, <<"type">>}, {utf8, <<"queue">>}}], QueueProperties),
    Body1 = {map, Body0},
    Body = iolist_to_binary(amqp10_framing:encode_bin(Body1)),

    HttpMethod = <<"POST">>,
    HttpRequestTarget = <<"/$management/entities">>,
    ContentType = <<"application/amqp-management+amqp;type=entity">>,
    Props = #{to => HttpRequestTarget,
              subject => HttpMethod,
              content_type => ContentType},

    case request(LinkPair, Props, Body) of
        {ok, Resp} ->
            case amqp10_msg:properties(Resp) of
                #{subject := <<"201">>,
                  content_type := <<"application/amqp-management+amqp;type=entity-collection">>} ->
                    RespBody = amqp10_msg:body_bin(Resp),
                    [{map, KVList}] = amqp10_framing:decode_bin(RespBody),
                    {ok, proplists:to_map(KVList)};
                _ ->
                    {error, Resp}
            end;
        Err ->
            Err
    end.

-spec bind_queue(link_pair(), binary(), binary(), binary(), #{binary() => amqp10_prim()}) ->
    ok | {error, term()}.
bind_queue(LinkPair, QueueName, ExchangeName, BindingKey, BindingArguments) ->
    bind(<<"queues">>, LinkPair, QueueName, ExchangeName, BindingKey, BindingArguments).

-spec bind_exchange(link_pair(), binary(), binary(), binary(), #{binary() => amqp10_prim()}) ->
    ok | {error, term()}.
bind_exchange(LinkPair, Destination, Source, BindingKey, BindingArguments) ->
    bind(<<"exchanges">>, LinkPair, Destination, Source, BindingKey, BindingArguments).

-spec bind(binary(), link_pair(), binary(), binary(), binary(), #{binary() => amqp10_prim()}) ->
    ok | {error, term()}.
bind(Type, LinkPair, Destination, Source, BindingKey, BindingArguments) ->
    KVList = maps:fold(
               fun(Key, TaggedVal = {T, _}, L)
                     when is_binary(Key) andalso is_atom(T) ->
                       [{{utf8, Key}, TaggedVal} | L]
               end, [], BindingArguments),
    Body0 = {map, [
                   {{utf8, <<"source">>}, {utf8, Source}},
                   {{utf8, <<"binding_key">>}, {utf8, BindingKey}},
                   {{utf8, <<"arguments">>}, {map, KVList}}
                  ]},
    Body = iolist_to_binary(amqp10_framing:encode_bin(Body0)),

    HttpMethod = <<"POST">>,
    HttpRequestTarget = <<"/$management/",
                          Type/binary, "/",
                          Destination/binary,
                          "/$management/entities">>,
    ContentType = <<"application/amqp-management+amqp;type=entity">>,
    Props = #{to => HttpRequestTarget,
              subject => HttpMethod,
              content_type => ContentType},

    case request(LinkPair, Props, Body) of
        {ok, Resp} ->
            case amqp10_msg:properties(Resp) of
                #{subject := <<"201">>} ->
                    ok;
                _ ->
                    {error, Resp}
            end;
        Err ->
            Err
    end.

-spec unbind_queue(link_pair(), binary(), binary(), binary(), #{binary() => amqp10_prim()}) ->
    ok | {error, term()}.
unbind_queue(LinkPair, QueueName, ExchangeName, BindingKey, BindingArguments) ->
    unbind(<<"queues">>, LinkPair, QueueName, ExchangeName, BindingKey, BindingArguments).

-spec unbind_exchange(link_pair(), binary(), binary(), binary(), #{binary() => amqp10_prim()}) ->
    ok | {error, term()}.
unbind_exchange(LinkPair, DestinationExchange, SourceExchange, BindingKey, BindingArguments) ->
    unbind(<<"exchanges">>, LinkPair, DestinationExchange, SourceExchange, BindingKey, BindingArguments).

-spec unbind(binary(), link_pair(), binary(), binary(), binary(), #{binary() => amqp10_prim()}) ->
    ok | {error, term()}.
unbind(Type, LinkPair, Destination, Source, BindingKey, BindingArguments) ->
    HttpMethod = <<"GET">>,
    HttpRequestTarget = <<"/$management/",
                          Type/binary, "/",
                          Destination/binary,
                          "/$management/bindings?source=", Source/binary>>,
    Props = #{to => HttpRequestTarget,
              subject => HttpMethod},

    case request(LinkPair, Props, <<>>) of
        {ok, Resp} ->
            case amqp10_msg:properties(Resp) of
                #{subject := <<"200">>,
                  content_type := <<"application/amqp-management+amqp">>} ->
                    RespBody = amqp10_msg:body_bin(Resp),
                    [{list, Bindings}] = amqp10_framing:decode_bin(RespBody),
                    case search_binding_uri(BindingKey, BindingArguments, Bindings) of
                        {ok, Uri} ->
                            delete_binding(LinkPair, Uri);
                        not_found ->
                            ok
                    end;
                _ ->
                    {error, Resp}
            end;
        Err ->
            Err
    end.

search_binding_uri(_, _, []) ->
    not_found;
search_binding_uri(BindingKey, BindingArguments, [{map, KVList} | Bindings]) ->
    case maps:from_list(KVList) of
        #{{utf8, <<"binding_key">>} := {utf8, BindingKey},
          {utf8, <<"arguments">>} := {map, Args},
          {utf8, <<"self">>} := {utf8, Uri}} ->
            Args = lists:map(fun({{utf8, Key}, TypeVal}) ->
                                     {Key, TypeVal}
                             end, Args),
            case maps:from_list(Args) =:= BindingArguments of
                true ->
                    {ok, Uri};
                false ->
                    search_binding_uri(BindingKey, BindingArguments, Bindings)
            end;
        _ ->
            search_binding_uri(BindingKey, BindingArguments, Bindings)
    end.

-spec delete_binding(link_pair(), binary()) ->
    ok | {error, term()}.
delete_binding(LinkPair, BindingUri) ->
    HttpMethod = <<"DELETE">>,
    Props = #{to => BindingUri,
              subject => HttpMethod},

    case request(LinkPair, Props, <<>>) of
        {ok, Resp} ->
            case amqp10_msg:properties(Resp) of
                #{subject := <<"204">>} ->
                    ok;
                _ ->
                    {error, Resp}
            end;
        Err ->
            Err
    end.

-spec purge_queue(link_pair(), binary()) ->
    {ok, map()} | {error, term()}.
purge_queue(LinkPair, QueueName) ->
    HttpMethod = <<"POST">>,
    HttpRequestTarget = <<"/$management/queues/", QueueName/binary, "/$management/purge">>,
    Props = #{to => HttpRequestTarget,
              subject => HttpMethod},
    purge_or_delete_queue(LinkPair, Props).

-spec delete_queue(link_pair(), binary()) ->
    {ok, map()} | {error, term()}.
delete_queue(LinkPair, QueueName) ->
    HttpMethod = <<"DELETE">>,
    HttpRequestTarget = <<"/$management/queues/", QueueName/binary>>,
    Props = #{to => HttpRequestTarget,
              subject => HttpMethod},
    purge_or_delete_queue(LinkPair, Props).

-spec purge_or_delete_queue(link_pair(), amqp10_msg:amqp10_properties()) ->
    {ok, map()} | {error, term()}.
purge_or_delete_queue(LinkPair, Props) ->
    case request(LinkPair, Props, <<>>) of
        {ok, Resp} ->
            case amqp10_msg:properties(Resp) of
                #{subject := <<"200">>,
                  content_type := <<"application/amqp-management+amqp">>} ->
                    RespBody = amqp10_msg:body_bin(Resp),
                    [{map, [
                            {{utf8, <<"message_count">>}, {ulong, Count}}
                           ]
                     }] = amqp10_framing:decode_bin(RespBody),
                    {ok, #{message_count => Count}};
                _ ->
                    {error, Resp}
            end;
        Err ->
            Err
    end.

-spec declare_exchange(link_pair(), exchange_properties()) ->
    {ok, map()} | {error, term()}.
declare_exchange(LinkPair, ExchangeProperties) ->
    Body0 = maps:fold(
              fun(name, V, Acc) when is_binary(V) ->
                      [{{utf8, <<"name">>}, {utf8, V}} | Acc];
                 (type, V, Acc) when is_binary(V) ->
                      [{{utf8, <<"exchange_type">>}, {utf8, V}} | Acc];
                 (durable, V, Acc) when is_boolean(V) ->
                      [{{utf8, <<"durable">>}, {boolean, V}} | Acc];
                 (auto_delete, V, Acc) when is_boolean(V) ->
                      [{{utf8, <<"auto_delete">>}, {boolean, V}} | Acc];
                 (internal, V, Acc) when is_boolean(V) ->
                      [{{utf8, <<"internal">>}, {boolean, V}} | Acc];
                 (arguments, V, Acc) ->
                      KVList = maps:fold(
                                 fun(K = <<"x-", _/binary>>, TaggedVal = {T, _}, L)
                                       when is_atom(T) ->
                                         [{{utf8, K}, TaggedVal} | L]
                                 end, [], V),
                      [{{utf8, <<"arguments">>}, {map, KVList}} | Acc]
              end, [{{utf8, <<"type">>}, {utf8, <<"exchange">>}}], ExchangeProperties),
    Body1 = {map, Body0},
    Body = iolist_to_binary(amqp10_framing:encode_bin(Body1)),

    HttpMethod = <<"POST">>,
    HttpRequestTarget = <<"/$management/entities">>,
    ContentType = <<"application/amqp-management+amqp;type=entity">>,
    Props = #{to => HttpRequestTarget,
              subject => HttpMethod,
              content_type => ContentType},

    case request(LinkPair, Props, Body) of
        {ok, Resp} ->
            case amqp10_msg:properties(Resp) of
                #{subject := <<"201">>,
                  content_type := <<"application/amqp-management+amqp;type=entity-collection">>} ->
                    RespBody = amqp10_msg:body_bin(Resp),
                    [{map, KVList}] = amqp10_framing:decode_bin(RespBody),
                    {ok, proplists:to_map(KVList)};
                _ ->
                    {error, Resp}
            end;
        Err ->
            Err
    end.

-spec delete_exchange(link_pair(), binary()) ->
    ok | {error, term()}.
delete_exchange(LinkPair, ExchangeName) ->
    HttpMethod = <<"DELETE">>,
    HttpRequestTarget = <<"/$management/exchanges/", ExchangeName/binary>>,
    Props = #{to => HttpRequestTarget,
              subject => HttpMethod},
    case request(LinkPair, Props, <<>>) of
        {ok, Resp} ->
            case amqp10_msg:properties(Resp) of
                #{subject := <<"204">>} ->
                    ok;
                _ ->
                    {error, Resp}
            end;
        Err ->
            Err
    end.

-spec request(link_pair(), amqp10_msg:amqp10_properties(), binary()) ->
    {ok, Response :: amqp10_msg:amqp10_msg()} | {error, term()}.
request(#link_pair{outgoing_link = OutgoingLink,
                   incoming_link = IncomingLink}, Properties, Body) ->
    MessageId = message_id(),
    Properties1 = Properties#{message_id => {binary, MessageId},
                              reply_to => <<"$me">>},
    Request = amqp10_msg:new(<<>>, Body, true),
    Request1 =  amqp10_msg:set_properties(Properties1, Request),
    ok = amqp10_client:flow_link_credit(IncomingLink, 1, never),
    case amqp10_client:send_msg(OutgoingLink, Request1) of
        ok ->
            receive {amqp10_msg, IncomingLink, Response} ->
                        #{correlation_id := MessageId} = amqp10_msg:properties(Response),
                        {ok, Response}
            after ?TIMEOUT ->
                      {error, response_timeout}
            end;
        Err ->
            Err
    end.

%% "The message producer is usually responsible for setting the message-id in
%% such a way that it is assured to be globally unique." [3.2.4]
-spec message_id() -> binary().
message_id() ->
    rand:bytes(8).
