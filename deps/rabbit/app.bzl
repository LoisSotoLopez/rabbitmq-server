load("@rules_erlang//:erlang_bytecode2.bzl", "erlang_bytecode")
load("@rules_erlang//:filegroup.bzl", "filegroup")

def all_beam_files(name = "all_beam_files"):
    filegroup(
        name = "beam_files",
        srcs = [":behaviours", ":other_beam"],
    )
    erlang_bytecode(
        name = "behaviours",
        srcs = [
            "src/gm.erl",
            "src/mc.erl",
            "src/rabbit_backing_queue.erl",
            "src/rabbit_credential_validator.erl",
            "src/rabbit_exchange_type.erl",
            "src/rabbit_mirror_queue_mode.erl",
            "src/rabbit_policy_merge_strategy.erl",
            "src/rabbit_queue_master_locator.erl",
            "src/rabbit_queue_type.erl",
            "src/rabbit_tracking.erl",
        ],
        hdrs = [":public_and_private_hdrs"],
        app_name = "rabbit",
        dest = "ebin",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "other_beam",
        srcs = native.glob(
            ["src/**/*.erl"],
            exclude = [
                "src/gm.erl",
                "src/mc.erl",
                "src/rabbit_backing_queue.erl",
                "src/rabbit_credential_validator.erl",
                "src/rabbit_exchange_type.erl",
                "src/rabbit_mirror_queue_mode.erl",
                "src/rabbit_policy_merge_strategy.erl",
                "src/rabbit_queue_master_locator.erl",
                "src/rabbit_queue_type.erl",
                "src/rabbit_tracking.erl",
            ],
        ),
        hdrs = [":public_and_private_hdrs"],
        app_name = "rabbit",
        beam = [":behaviours"],
        dest = "ebin",
        erlc_opts = "//:erlc_opts",
        deps = [
            "//deps/amqp10_common:erlang_app",
            "//deps/rabbit_common:erlang_app",
            "@ra//:erlang_app",
            "@ranch//:erlang_app",
            "@stdout_formatter//:erlang_app",
        ],
    )

def all_test_beam_files(name = "all_test_beam_files"):
    filegroup(
        name = "test_beam_files",
        testonly = True,
        srcs = [":test_behaviours", ":test_other_beam"],
    )
    erlang_bytecode(
        name = "test_behaviours",
        testonly = True,
        srcs = [
            "src/gm.erl",
            "src/mc.erl",
            "src/rabbit_backing_queue.erl",
            "src/rabbit_credential_validator.erl",
            "src/rabbit_exchange_type.erl",
            "src/rabbit_mirror_queue_mode.erl",
            "src/rabbit_policy_merge_strategy.erl",
            "src/rabbit_queue_master_locator.erl",
            "src/rabbit_queue_type.erl",
            "src/rabbit_tracking.erl",
        ],
        hdrs = [":public_and_private_hdrs"],
        app_name = "rabbit",
        dest = "test",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_other_beam",
        testonly = True,
        srcs = native.glob(
            ["src/**/*.erl"],
            exclude = [
                "src/gm.erl",
                "src/mc.erl",
                "src/rabbit_backing_queue.erl",
                "src/rabbit_credential_validator.erl",
                "src/rabbit_exchange_type.erl",
                "src/rabbit_mirror_queue_mode.erl",
                "src/rabbit_policy_merge_strategy.erl",
                "src/rabbit_queue_master_locator.erl",
                "src/rabbit_queue_type.erl",
                "src/rabbit_tracking.erl",
            ],
        ),
        hdrs = [":public_and_private_hdrs"],
        app_name = "rabbit",
        beam = [":test_behaviours"],
        dest = "test",
        erlc_opts = "//:test_erlc_opts",
        deps = [
            "//deps/amqp10_common:erlang_app",
            "//deps/rabbit_common:erlang_app",
            "@ra//:erlang_app",
            "@ranch//:erlang_app",
            "@stdout_formatter//:erlang_app",
        ],
    )

def all_srcs(name = "all_srcs"):
    filegroup(
        name = "all_srcs",
        srcs = [":public_and_private_hdrs", ":srcs"],
    )
    filegroup(
        name = "public_and_private_hdrs",
        srcs = [":private_hdrs", ":public_hdrs"],
    )
    filegroup(
        name = "public_hdrs",
        srcs = [
            "include/amqqueue.hrl",
            "include/amqqueue_v2.hrl",
            "include/gm_specs.hrl",
            "include/rabbit_global_counters.hrl",
            "include/vhost.hrl",
            "include/vhost_v2.hrl",
        ],
    )

    filegroup(
        name = "priv",
        srcs = ["priv/schema/rabbit.schema"],  #keep
    )
    filegroup(
        name = "private_hdrs",
        srcs = [
            "src/mc.hrl",
            "src/rabbit_feature_flags.hrl",
            "src/rabbit_fifo.hrl",
            "src/rabbit_fifo_dlx.hrl",
            "src/rabbit_fifo_v0.hrl",
            "src/rabbit_fifo_v1.hrl",
            "src/rabbit_stream_coordinator.hrl",
            "src/rabbit_stream_sac_coordinator.hrl",
        ],
    )
    filegroup(
        name = "srcs",
        srcs = [
            "src/amqqueue.erl",
            "src/background_gc.erl",
            "src/code_server_cache.erl",
            "src/gatherer.erl",
            "src/gm.erl",
            "src/internal_user.erl",
            "src/lqueue.erl",
            "src/mc.erl",
            "src/mc_amqp.erl",
            "src/mc_amqpl.erl",
            "src/mc_compat.erl",
            "src/mc_util.erl",
            "src/mirrored_supervisor.erl",
            "src/mirrored_supervisor_sups.erl",
            "src/pg_local.erl",
            "src/pid_recomposition.erl",
            "src/rabbit.erl",
            "src/rabbit_access_control.erl",
            "src/rabbit_alarm.erl",
            "src/rabbit_amqqueue.erl",
            "src/rabbit_amqqueue_process.erl",
            "src/rabbit_amqqueue_sup.erl",
            "src/rabbit_amqqueue_sup_sup.erl",
            "src/rabbit_auth_backend_internal.erl",
            "src/rabbit_auth_mechanism_amqplain.erl",
            "src/rabbit_auth_mechanism_cr_demo.erl",
            "src/rabbit_auth_mechanism_plain.erl",
            "src/rabbit_autoheal.erl",
            "src/rabbit_backing_queue.erl",
            "src/rabbit_basic.erl",
            "src/rabbit_binding.erl",
            "src/rabbit_boot_steps.erl",
            "src/rabbit_channel.erl",
            "src/rabbit_channel_interceptor.erl",
            "src/rabbit_channel_sup.erl",
            "src/rabbit_channel_sup_sup.erl",
            "src/rabbit_channel_tracking.erl",
            "src/rabbit_channel_tracking_handler.erl",
            "src/rabbit_classic_queue.erl",
            "src/rabbit_classic_queue_index_v2.erl",
            "src/rabbit_classic_queue_store_v2.erl",
            "src/rabbit_client_sup.erl",
            "src/rabbit_config.erl",
            "src/rabbit_confirms.erl",
            "src/rabbit_connection_helper_sup.erl",
            "src/rabbit_connection_sup.erl",
            "src/rabbit_connection_tracking.erl",
            "src/rabbit_connection_tracking_handler.erl",
            "src/rabbit_control_pbe.erl",
            "src/rabbit_core_ff.erl",
            "src/rabbit_core_metrics_gc.erl",
            "src/rabbit_credential_validation.erl",
            "src/rabbit_credential_validator.erl",
            "src/rabbit_credential_validator_accept_everything.erl",
            "src/rabbit_credential_validator_min_password_length.erl",
            "src/rabbit_credential_validator_password_regexp.erl",
            "src/rabbit_cuttlefish.erl",
            "src/rabbit_db.erl",
            "src/rabbit_db_binding.erl",
            "src/rabbit_db_cluster.erl",
            "src/rabbit_db_exchange.erl",
            "src/rabbit_db_maintenance.erl",
            "src/rabbit_db_msup.erl",
            "src/rabbit_db_policy.erl",
            "src/rabbit_db_queue.erl",
            "src/rabbit_db_rtparams.erl",
            "src/rabbit_db_topic_exchange.erl",
            "src/rabbit_db_user.erl",
            "src/rabbit_db_vhost.erl",
            "src/rabbit_db_vhost_defaults.erl",
            "src/rabbit_dead_letter.erl",
            "src/rabbit_definitions.erl",
            "src/rabbit_definitions_hashing.erl",
            "src/rabbit_definitions_import_https.erl",
            "src/rabbit_definitions_import_local_filesystem.erl",
            "src/rabbit_deprecated_features.erl",
            "src/rabbit_diagnostics.erl",
            "src/rabbit_direct.erl",
            "src/rabbit_direct_reply_to.erl",
            "src/rabbit_disk_monitor.erl",
            "src/rabbit_epmd_monitor.erl",
            "src/rabbit_event_consumer.erl",
            "src/rabbit_exchange.erl",
            "src/rabbit_exchange_decorator.erl",
            "src/rabbit_exchange_parameters.erl",
            "src/rabbit_exchange_type.erl",
            "src/rabbit_exchange_type_direct.erl",
            "src/rabbit_exchange_type_fanout.erl",
            "src/rabbit_exchange_type_headers.erl",
            "src/rabbit_exchange_type_invalid.erl",
            "src/rabbit_exchange_type_topic.erl",
            "src/rabbit_feature_flags.erl",
            "src/rabbit_ff_controller.erl",
            "src/rabbit_ff_extra.erl",
            "src/rabbit_ff_registry.erl",
            "src/rabbit_ff_registry_factory.erl",
            "src/rabbit_ff_registry_wrapper.erl",
            "src/rabbit_fhc_helpers.erl",
            "src/rabbit_fifo.erl",
            "src/rabbit_fifo_client.erl",
            "src/rabbit_fifo_dlx.erl",
            "src/rabbit_fifo_dlx_client.erl",
            "src/rabbit_fifo_dlx_sup.erl",
            "src/rabbit_fifo_dlx_worker.erl",
            "src/rabbit_fifo_index.erl",
            "src/rabbit_fifo_v0.erl",
            "src/rabbit_fifo_v1.erl",
            "src/rabbit_file.erl",
            "src/rabbit_global_counters.erl",
            "src/rabbit_guid.erl",
            "src/rabbit_health_check.erl",
            "src/rabbit_limiter.erl",
            "src/rabbit_log_channel.erl",
            "src/rabbit_log_connection.erl",
            "src/rabbit_log_mirroring.erl",
            "src/rabbit_log_prelaunch.erl",
            "src/rabbit_log_queue.erl",
            "src/rabbit_log_tail.erl",
            "src/rabbit_logger_exchange_h.erl",
            "src/rabbit_looking_glass.erl",
            "src/rabbit_maintenance.erl",
            "src/rabbit_memory_monitor.erl",
            "src/rabbit_message_interceptor.erl",
            "src/rabbit_metrics.erl",
            "src/rabbit_mirror_queue_coordinator.erl",
            "src/rabbit_mirror_queue_master.erl",
            "src/rabbit_mirror_queue_misc.erl",
            "src/rabbit_mirror_queue_mode.erl",
            "src/rabbit_mirror_queue_mode_all.erl",
            "src/rabbit_mirror_queue_mode_exactly.erl",
            "src/rabbit_mirror_queue_mode_nodes.erl",
            "src/rabbit_mirror_queue_slave.erl",
            "src/rabbit_mirror_queue_sync.erl",
            "src/rabbit_mnesia.erl",
            "src/rabbit_mnesia_rename.erl",
            "src/rabbit_msg_file.erl",
            "src/rabbit_msg_record.erl",
            "src/rabbit_msg_store.erl",
            "src/rabbit_msg_store_ets_index.erl",
            "src/rabbit_msg_store_gc.erl",
            "src/rabbit_networking.erl",
            "src/rabbit_networking_store.erl",
            "src/rabbit_node_monitor.erl",
            "src/rabbit_nodes.erl",
            "src/rabbit_observer_cli.erl",
            "src/rabbit_observer_cli_classic_queues.erl",
            "src/rabbit_observer_cli_quorum_queues.erl",
            "src/rabbit_osiris_metrics.erl",
            "src/rabbit_parameter_validation.erl",
            "src/rabbit_peer_discovery.erl",
            "src/rabbit_peer_discovery_classic_config.erl",
            "src/rabbit_peer_discovery_dns.erl",
            "src/rabbit_plugins.erl",
            "src/rabbit_policies.erl",
            "src/rabbit_policy.erl",
            "src/rabbit_policy_merge_strategy.erl",
            "src/rabbit_prelaunch_cluster.erl",
            "src/rabbit_prelaunch_enabled_plugins_file.erl",
            "src/rabbit_prelaunch_feature_flags.erl",
            "src/rabbit_prelaunch_logging.erl",
            "src/rabbit_prequeue.erl",
            "src/rabbit_priority_queue.erl",
            "src/rabbit_process.erl",
            "src/rabbit_queue_consumers.erl",
            "src/rabbit_queue_decorator.erl",
            "src/rabbit_queue_index.erl",
            "src/rabbit_queue_location.erl",
            "src/rabbit_queue_location_client_local.erl",
            "src/rabbit_queue_location_min_masters.erl",
            "src/rabbit_queue_location_random.erl",
            "src/rabbit_queue_location_validator.erl",
            "src/rabbit_queue_master_location_misc.erl",
            "src/rabbit_queue_master_locator.erl",
            "src/rabbit_queue_type.erl",
            "src/rabbit_queue_type_util.erl",
            "src/rabbit_quorum_memory_manager.erl",
            "src/rabbit_quorum_queue.erl",
            "src/rabbit_quorum_queue_periodic_membership_reconciliation.erl",
            "src/rabbit_ra_registry.erl",
            "src/rabbit_ra_systems.erl",
            "src/rabbit_reader.erl",
            "src/rabbit_recovery_terms.erl",
            "src/rabbit_release_series.erl",
            "src/rabbit_restartable_sup.erl",
            "src/rabbit_router.erl",
            "src/rabbit_runtime_parameters.erl",
            "src/rabbit_ssl.erl",
            "src/rabbit_stream_coordinator.erl",
            "src/rabbit_stream_queue.erl",
            "src/rabbit_stream_sac_coordinator.erl",
            "src/rabbit_sup.erl",
            "src/rabbit_sysmon_handler.erl",
            "src/rabbit_sysmon_minder.erl",
            "src/rabbit_table.erl",
            "src/rabbit_time_travel_dbg.erl",
            "src/rabbit_trace.erl",
            "src/rabbit_tracking.erl",
            "src/rabbit_tracking_store.erl",
            "src/rabbit_upgrade_preparation.erl",
            "src/rabbit_variable_queue.erl",
            "src/rabbit_version.erl",
            "src/rabbit_vhost.erl",
            "src/rabbit_vhost_limit.erl",
            "src/rabbit_vhost_msg_store.erl",
            "src/rabbit_vhost_process.erl",
            "src/rabbit_vhost_sup.erl",
            "src/rabbit_vhost_sup_sup.erl",
            "src/rabbit_vhost_sup_wrapper.erl",
            "src/rabbit_vm.erl",
            "src/supervised_lifecycle.erl",
            "src/tcp_listener.erl",
            "src/tcp_listener_sup.erl",
            "src/term_to_binary_compat.erl",
            "src/vhost.erl",
        ],
    )
    filegroup(
        name = "license_files",
        srcs = [
            "LICENSE",
            "LICENSE-MPL-RabbitMQ",
        ],
    )

def test_suite_beam_files(name = "test_suite_beam_files"):
    erlang_bytecode(
        name = "amqqueue_backward_compatibility_SUITE_beam_files",
        testonly = True,
        srcs = ["test/amqqueue_backward_compatibility_SUITE.erl"],
        outs = ["test/amqqueue_backward_compatibility_SUITE.beam"],
        hdrs = ["include/amqqueue.hrl", "include/amqqueue_v2.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "backing_queue_SUITE_beam_files",
        testonly = True,
        srcs = ["test/backing_queue_SUITE.erl"],
        outs = ["test/backing_queue_SUITE.beam"],
        hdrs = ["include/amqqueue.hrl", "include/amqqueue_v2.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "channel_interceptor_SUITE_beam_files",
        testonly = True,
        srcs = ["test/channel_interceptor_SUITE.erl"],
        outs = ["test/channel_interceptor_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "channel_operation_timeout_SUITE_beam_files",
        testonly = True,
        srcs = ["test/channel_operation_timeout_SUITE.erl"],
        outs = ["test/channel_operation_timeout_SUITE.beam"],
        hdrs = ["include/amqqueue.hrl", "include/amqqueue_v2.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "classic_queue_prop_SUITE_beam_files",
        testonly = True,
        srcs = ["test/classic_queue_prop_SUITE.erl"],
        outs = ["test/classic_queue_prop_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "@proper//:erlang_app"],
    )
    erlang_bytecode(
        name = "cluster_SUITE_beam_files",
        testonly = True,
        srcs = ["test/cluster_SUITE.erl"],
        outs = ["test/cluster_SUITE.beam"],
        hdrs = ["include/amqqueue.hrl", "include/amqqueue_v2.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )

    erlang_bytecode(
        name = "cluster_rename_SUITE_beam_files",
        testonly = True,
        srcs = ["test/cluster_rename_SUITE.erl"],
        outs = ["test/cluster_rename_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "clustering_management_SUITE_beam_files",
        testonly = True,
        srcs = ["test/clustering_management_SUITE.erl"],
        outs = ["test/clustering_management_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "clustering_recovery_SUITE_beam_files",
        testonly = True,
        srcs = ["test/clustering_recovery_SUITE.erl"],
        outs = ["test/clustering_recovery_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "config_schema_SUITE_beam_files",
        testonly = True,
        srcs = ["test/config_schema_SUITE.erl"],
        outs = ["test/config_schema_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "confirms_rejects_SUITE_beam_files",
        testonly = True,
        srcs = ["test/confirms_rejects_SUITE.erl"],
        outs = ["test/confirms_rejects_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "consumer_timeout_SUITE_beam_files",
        testonly = True,
        srcs = ["test/consumer_timeout_SUITE.erl"],
        outs = ["test/consumer_timeout_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "crashing_queues_SUITE_beam_files",
        testonly = True,
        srcs = ["test/crashing_queues_SUITE.erl"],
        outs = ["test/crashing_queues_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "dead_lettering_SUITE_beam_files",
        testonly = True,
        srcs = ["test/dead_lettering_SUITE.erl"],
        outs = ["test/dead_lettering_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "definition_import_SUITE_beam_files",
        testonly = True,
        srcs = ["test/definition_import_SUITE.erl"],
        outs = ["test/definition_import_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "deprecated_features_SUITE_beam_files",
        testonly = True,
        srcs = ["test/deprecated_features_SUITE.erl"],
        outs = ["test/deprecated_features_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "direct_exchange_routing_v2_SUITE_beam_files",
        testonly = True,
        srcs = ["test/direct_exchange_routing_v2_SUITE.erl"],
        outs = ["test/direct_exchange_routing_v2_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "disconnect_detected_during_alarm_SUITE_beam_files",
        testonly = True,
        srcs = ["test/disconnect_detected_during_alarm_SUITE.erl"],
        outs = ["test/disconnect_detected_during_alarm_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "disk_monitor_SUITE_beam_files",
        testonly = True,
        srcs = ["test/disk_monitor_SUITE.erl"],
        outs = ["test/disk_monitor_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "dynamic_ha_SUITE_beam_files",
        testonly = True,
        srcs = ["test/dynamic_ha_SUITE.erl"],
        outs = ["test/dynamic_ha_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app", "@proper//:erlang_app"],
    )
    erlang_bytecode(
        name = "dynamic_qq_SUITE_beam_files",
        testonly = True,
        srcs = ["test/dynamic_qq_SUITE.erl"],
        outs = ["test/dynamic_qq_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "eager_sync_SUITE_beam_files",
        testonly = True,
        srcs = ["test/eager_sync_SUITE.erl"],
        outs = ["test/eager_sync_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "feature_flags_SUITE_beam_files",
        testonly = True,
        srcs = ["test/feature_flags_SUITE.erl"],
        outs = ["test/feature_flags_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "feature_flags_v2_SUITE_beam_files",
        testonly = True,
        srcs = ["test/feature_flags_v2_SUITE.erl"],
        outs = ["test/feature_flags_v2_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "feature_flags_with_unpriveleged_user_SUITE_beam_files",
        testonly = True,
        srcs = ["test/feature_flags_with_unpriveleged_user_SUITE.erl"],
        outs = ["test/feature_flags_with_unpriveleged_user_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "list_consumers_sanity_check_SUITE_beam_files",
        testonly = True,
        srcs = ["test/list_consumers_sanity_check_SUITE.erl"],
        outs = ["test/list_consumers_sanity_check_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "list_queues_online_and_offline_SUITE_beam_files",
        testonly = True,
        srcs = ["test/list_queues_online_and_offline_SUITE.erl"],
        outs = ["test/list_queues_online_and_offline_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "logging_SUITE_beam_files",
        testonly = True,
        srcs = ["test/logging_SUITE.erl"],
        outs = ["test/logging_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "lqueue_SUITE_beam_files",
        testonly = True,
        srcs = ["test/lqueue_SUITE.erl"],
        outs = ["test/lqueue_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["@proper//:erlang_app"],
    )
    erlang_bytecode(
        name = "maintenance_mode_SUITE_beam_files",
        testonly = True,
        srcs = ["test/maintenance_mode_SUITE.erl"],
        outs = ["test/maintenance_mode_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "many_node_ha_SUITE_beam_files",
        testonly = True,
        srcs = ["test/many_node_ha_SUITE.erl"],
        outs = ["test/many_node_ha_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "message_size_limit_SUITE_beam_files",
        testonly = True,
        srcs = ["test/message_size_limit_SUITE.erl"],
        outs = ["test/message_size_limit_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "metrics_SUITE_beam_files",
        testonly = True,
        srcs = ["test/metrics_SUITE.erl"],
        outs = ["test/metrics_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbit_common:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app", "@proper//:erlang_app"],
    )
    erlang_bytecode(
        name = "mirrored_supervisor_SUITE_beam_files",
        testonly = True,
        srcs = ["test/mirrored_supervisor_SUITE.erl"],
        outs = ["test/mirrored_supervisor_SUITE.beam"],
        app_name = "rabbit",
        beam = ["ebin/mirrored_supervisor.beam"],
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "msg_store_SUITE_beam_files",
        testonly = True,
        srcs = ["test/msg_store_SUITE.erl"],
        outs = ["test/msg_store_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "peer_discovery_classic_config_SUITE_beam_files",
        testonly = True,
        srcs = ["test/peer_discovery_classic_config_SUITE.erl"],
        outs = ["test/peer_discovery_classic_config_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "peer_discovery_dns_SUITE_beam_files",
        testonly = True,
        srcs = ["test/peer_discovery_dns_SUITE.erl"],
        outs = ["test/peer_discovery_dns_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "per_user_connection_channel_limit_SUITE_beam_files",
        testonly = True,
        srcs = ["test/per_user_connection_channel_limit_SUITE.erl"],
        outs = ["test/per_user_connection_channel_limit_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "per_user_connection_channel_limit_partitions_SUITE_beam_files",
        testonly = True,
        srcs = ["test/per_user_connection_channel_limit_partitions_SUITE.erl"],
        outs = ["test/per_user_connection_channel_limit_partitions_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "per_user_connection_channel_tracking_SUITE_beam_files",
        testonly = True,
        srcs = ["test/per_user_connection_channel_tracking_SUITE.erl"],
        outs = ["test/per_user_connection_channel_tracking_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "per_user_connection_tracking_SUITE_beam_files",
        testonly = True,
        srcs = ["test/per_user_connection_tracking_SUITE.erl"],
        outs = ["test/per_user_connection_tracking_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "per_vhost_connection_limit_SUITE_beam_files",
        testonly = True,
        srcs = ["test/per_vhost_connection_limit_SUITE.erl"],
        outs = ["test/per_vhost_connection_limit_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "per_vhost_connection_limit_partitions_SUITE_beam_files",
        testonly = True,
        srcs = ["test/per_vhost_connection_limit_partitions_SUITE.erl"],
        outs = ["test/per_vhost_connection_limit_partitions_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "per_vhost_msg_store_SUITE_beam_files",
        testonly = True,
        srcs = ["test/per_vhost_msg_store_SUITE.erl"],
        outs = ["test/per_vhost_msg_store_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "per_vhost_queue_limit_SUITE_beam_files",
        testonly = True,
        srcs = ["test/per_vhost_queue_limit_SUITE.erl"],
        outs = ["test/per_vhost_queue_limit_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "policy_SUITE_beam_files",
        testonly = True,
        srcs = ["test/policy_SUITE.erl"],
        outs = ["test/policy_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "priority_queue_SUITE_beam_files",
        testonly = True,
        srcs = ["test/priority_queue_SUITE.erl"],
        outs = ["test/priority_queue_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "priority_queue_recovery_SUITE_beam_files",
        testonly = True,
        srcs = ["test/priority_queue_recovery_SUITE.erl"],
        outs = ["test/priority_queue_recovery_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "product_info_SUITE_beam_files",
        testonly = True,
        srcs = ["test/product_info_SUITE.erl"],
        outs = ["test/product_info_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "proxy_protocol_SUITE_beam_files",
        testonly = True,
        srcs = ["test/proxy_protocol_SUITE.erl"],
        outs = ["test/proxy_protocol_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "publisher_confirms_parallel_SUITE_beam_files",
        testonly = True,
        srcs = ["test/publisher_confirms_parallel_SUITE.erl"],
        outs = ["test/publisher_confirms_parallel_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "queue_length_limits_SUITE_beam_files",
        testonly = True,
        srcs = ["test/queue_length_limits_SUITE.erl"],
        outs = ["test/queue_length_limits_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "queue_master_location_SUITE_beam_files",
        testonly = True,
        srcs = ["test/queue_master_location_SUITE.erl"],
        outs = ["test/queue_master_location_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "queue_parallel_SUITE_beam_files",
        testonly = True,
        srcs = ["test/queue_parallel_SUITE.erl"],
        outs = ["test/queue_parallel_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "queue_type_SUITE_beam_files",
        testonly = True,
        srcs = ["test/queue_type_SUITE.erl"],
        outs = ["test/queue_type_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "quorum_queue_SUITE_beam_files",
        testonly = True,
        srcs = ["test/quorum_queue_SUITE.erl"],
        outs = ["test/quorum_queue_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_confirms_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_confirms_SUITE.erl"],
        outs = ["test/rabbit_confirms_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "rabbit_core_metrics_gc_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_core_metrics_gc_SUITE.erl"],
        outs = ["test/rabbit_core_metrics_gc_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_direct_reply_to_prop_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_direct_reply_to_prop_SUITE.erl"],
        outs = ["test/rabbit_direct_reply_to_prop_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["@proper//:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_fifo_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_fifo_SUITE.erl"],
        outs = ["test/rabbit_fifo_SUITE.beam"],
        hdrs = ["src/rabbit_fifo.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_fifo_dlx_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_fifo_dlx_SUITE.erl"],
        outs = ["test/rabbit_fifo_dlx_SUITE.beam"],
        hdrs = ["src/rabbit_fifo.hrl", "src/rabbit_fifo_dlx.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_fifo_dlx_integration_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_fifo_dlx_integration_SUITE.erl"],
        outs = ["test/rabbit_fifo_dlx_integration_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_fifo_int_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_fifo_int_SUITE.erl"],
        outs = ["test/rabbit_fifo_int_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_fifo_prop_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_fifo_prop_SUITE.erl"],
        outs = ["test/rabbit_fifo_prop_SUITE.beam"],
        hdrs = ["src/rabbit_fifo.hrl", "src/rabbit_fifo_dlx.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "@proper//:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_fifo_v0_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_fifo_v0_SUITE.erl"],
        outs = ["test/rabbit_fifo_v0_SUITE.beam"],
        hdrs = ["src/rabbit_fifo_v0.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_msg_record_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_msg_record_SUITE.erl"],
        outs = ["test/rabbit_msg_record_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp10_common:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_stream_coordinator_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_stream_coordinator_SUITE.erl"],
        outs = ["test/rabbit_stream_coordinator_SUITE.beam"],
        hdrs = ["src/rabbit_stream_coordinator.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_stream_queue_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_stream_queue_SUITE.erl"],
        outs = ["test/rabbit_stream_queue_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app", "@proper//:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_stream_sac_coordinator_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_stream_sac_coordinator_SUITE.erl"],
        outs = ["test/rabbit_stream_sac_coordinator_SUITE.beam"],
        hdrs = ["src/rabbit_stream_sac_coordinator.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "rabbitmq_queues_cli_integration_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbitmq_queues_cli_integration_SUITE.erl"],
        outs = ["test/rabbitmq_queues_cli_integration_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbitmqctl_integration_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbitmqctl_integration_SUITE.erl"],
        outs = ["test/rabbitmqctl_integration_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbitmqctl_shutdown_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbitmqctl_shutdown_SUITE.erl"],
        outs = ["test/rabbitmqctl_shutdown_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "signal_handling_SUITE_beam_files",
        testonly = True,
        srcs = ["test/signal_handling_SUITE.erl"],
        outs = ["test/signal_handling_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "simple_ha_SUITE_beam_files",
        testonly = True,
        srcs = ["test/simple_ha_SUITE.erl"],
        outs = ["test/simple_ha_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "single_active_consumer_SUITE_beam_files",
        testonly = True,
        srcs = ["test/single_active_consumer_SUITE.erl"],
        outs = ["test/single_active_consumer_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "sync_detection_SUITE_beam_files",
        testonly = True,
        srcs = ["test/sync_detection_SUITE.erl"],
        outs = ["test/sync_detection_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "term_to_binary_compat_prop_SUITE_beam_files",
        testonly = True,
        srcs = ["test/term_to_binary_compat_prop_SUITE.erl"],
        outs = ["test/term_to_binary_compat_prop_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "@proper//:erlang_app"],
    )
    erlang_bytecode(
        name = "test_channel_operation_timeout_test_queue_beam",
        testonly = True,
        srcs = ["test/channel_operation_timeout_test_queue.erl"],
        outs = ["test/channel_operation_timeout_test_queue.beam"],
        app_name = "rabbit",
        beam = ["ebin/rabbit_backing_queue.beam"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_dummy_event_receiver_beam",
        testonly = True,
        srcs = ["test/dummy_event_receiver.erl"],
        outs = ["test/dummy_event_receiver.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_dummy_interceptor_beam",
        testonly = True,
        srcs = ["test/dummy_interceptor.erl"],
        outs = ["test/dummy_interceptor.beam"],
        app_name = "rabbit",
        beam = ["ebin/rabbit_channel_interceptor.beam"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_dummy_runtime_parameters_beam",
        testonly = True,
        srcs = ["test/dummy_runtime_parameters.erl"],
        outs = ["test/dummy_runtime_parameters.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_dummy_supervisor2_beam",
        testonly = True,
        srcs = ["test/dummy_supervisor2.erl"],
        outs = ["test/dummy_supervisor2.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_failing_dummy_interceptor_beam",
        testonly = True,
        srcs = ["test/failing_dummy_interceptor.erl"],
        outs = ["test/failing_dummy_interceptor.beam"],
        app_name = "rabbit",
        beam = ["ebin/rabbit_channel_interceptor.beam"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_mirrored_supervisor_SUITE_gs_beam",
        testonly = True,
        srcs = ["test/mirrored_supervisor_SUITE_gs.erl"],
        outs = ["test/mirrored_supervisor_SUITE_gs.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "test_quorum_queue_utils_beam",
        testonly = True,
        srcs = ["test/quorum_queue_utils.erl"],
        outs = ["test/quorum_queue_utils.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "test_rabbit_auth_backend_context_propagation_mock_beam",
        testonly = True,
        srcs = ["test/rabbit_auth_backend_context_propagation_mock.erl"],
        outs = ["test/rabbit_auth_backend_context_propagation_mock.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_dummy_protocol_connection_info_beam",
        testonly = True,
        srcs = ["test/rabbit_dummy_protocol_connection_info.erl"],
        outs = ["test/rabbit_dummy_protocol_connection_info.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "test_rabbit_foo_protocol_connection_info_beam",
        testonly = True,
        srcs = ["test/rabbit_foo_protocol_connection_info.erl"],
        outs = ["test/rabbit_foo_protocol_connection_info.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "test_rabbit_ha_test_consumer_beam",
        testonly = True,
        srcs = ["test/rabbit_ha_test_consumer.erl"],
        outs = ["test/rabbit_ha_test_consumer.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_ha_test_producer_beam",
        testonly = True,
        srcs = ["test/rabbit_ha_test_producer.erl"],
        outs = ["test/rabbit_ha_test_producer.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "test_test_util_beam",
        testonly = True,
        srcs = ["test/test_util.erl"],
        outs = ["test/test_util.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "topic_permission_SUITE_beam_files",
        testonly = True,
        srcs = ["test/topic_permission_SUITE.erl"],
        outs = ["test/topic_permission_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_access_control_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_access_control_SUITE.erl"],
        outs = ["test/unit_access_control_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_access_control_authn_authz_context_propagation_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_access_control_authn_authz_context_propagation_SUITE.erl"],
        outs = ["test/unit_access_control_authn_authz_context_propagation_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_access_control_credential_validation_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_access_control_credential_validation_SUITE.erl"],
        outs = ["test/unit_access_control_credential_validation_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["@proper//:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_amqp091_content_framing_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_amqp091_content_framing_SUITE.erl"],
        outs = ["test/unit_amqp091_content_framing_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_amqp091_server_properties_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_amqp091_server_properties_SUITE.erl"],
        outs = ["test/unit_amqp091_server_properties_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_app_management_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_app_management_SUITE.erl"],
        outs = ["test/unit_app_management_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_classic_mirrored_queue_sync_throttling_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_classic_mirrored_queue_sync_throttling_SUITE.erl"],
        outs = ["test/unit_classic_mirrored_queue_sync_throttling_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_classic_mirrored_queue_throughput_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_classic_mirrored_queue_throughput_SUITE.erl"],
        outs = ["test/unit_classic_mirrored_queue_throughput_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_cluster_formation_locking_mocks_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_cluster_formation_locking_mocks_SUITE.erl"],
        outs = ["test/unit_cluster_formation_locking_mocks_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_collections_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_collections_SUITE.erl"],
        outs = ["test/unit_collections_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_config_value_encryption_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_config_value_encryption_SUITE.erl"],
        outs = ["test/unit_config_value_encryption_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_connection_tracking_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_connection_tracking_SUITE.erl"],
        outs = ["test/unit_connection_tracking_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_credit_flow_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_credit_flow_SUITE.erl"],
        outs = ["test/unit_credit_flow_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_disk_monitor_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_disk_monitor_SUITE.erl"],
        outs = ["test/unit_disk_monitor_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_file_handle_cache_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_file_handle_cache_SUITE.erl"],
        outs = ["test/unit_file_handle_cache_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_gen_server2_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_gen_server2_SUITE.erl"],
        outs = ["test/unit_gen_server2_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_gm_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_gm_SUITE.erl"],
        outs = ["test/unit_gm_SUITE.beam"],
        hdrs = ["include/gm_specs.hrl"],
        app_name = "rabbit",
        beam = ["ebin/gm.beam"],
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_log_management_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_log_management_SUITE.erl"],
        outs = ["test/unit_log_management_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_operator_policy_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_operator_policy_SUITE.erl"],
        outs = ["test/unit_operator_policy_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_pg_local_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_pg_local_SUITE.erl"],
        outs = ["test/unit_pg_local_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_plugin_directories_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_plugin_directories_SUITE.erl"],
        outs = ["test/unit_plugin_directories_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_plugin_versioning_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_plugin_versioning_SUITE.erl"],
        outs = ["test/unit_plugin_versioning_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_policy_validators_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_policy_validators_SUITE.erl"],
        outs = ["test/unit_policy_validators_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_priority_queue_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_priority_queue_SUITE.erl"],
        outs = ["test/unit_priority_queue_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_queue_consumers_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_queue_consumers_SUITE.erl"],
        outs = ["test/unit_queue_consumers_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_stats_and_metrics_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_stats_and_metrics_SUITE.erl"],
        outs = ["test/unit_stats_and_metrics_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_supervisor2_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_supervisor2_SUITE.erl"],
        outs = ["test/unit_supervisor2_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_vm_memory_monitor_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_vm_memory_monitor_SUITE.erl"],
        outs = ["test/unit_vm_memory_monitor_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "upgrade_preparation_SUITE_beam_files",
        testonly = True,
        srcs = ["test/upgrade_preparation_SUITE.erl"],
        outs = ["test/upgrade_preparation_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "vhost_SUITE_beam_files",
        testonly = True,
        srcs = ["test/vhost_SUITE.erl"],
        outs = ["test/vhost_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_cuttlefish_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_cuttlefish_SUITE.erl"],
        outs = ["test/rabbit_cuttlefish_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unicode_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unicode_SUITE.erl"],
        outs = ["test/unicode_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "bindings_SUITE_beam_files",
        testonly = True,
        srcs = ["test/bindings_SUITE.erl"],
        outs = ["test/bindings_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "exchanges_SUITE_beam_files",
        testonly = True,
        srcs = ["test/exchanges_SUITE.erl"],
        outs = ["test/exchanges_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_db_binding_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_db_binding_SUITE.erl"],
        outs = ["test/rabbit_db_binding_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_db_exchange_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_db_exchange_SUITE.erl"],
        outs = ["test/rabbit_db_exchange_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_db_maintenance_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_db_maintenance_SUITE.erl"],
        outs = ["test/rabbit_db_maintenance_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "rabbit_db_msup_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_db_msup_SUITE.erl"],
        outs = ["test/rabbit_db_msup_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_db_policy_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_db_policy_SUITE.erl"],
        outs = ["test/rabbit_db_policy_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_db_queue_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_db_queue_SUITE.erl"],
        outs = ["test/rabbit_db_queue_SUITE.beam"],
        hdrs = ["include/amqqueue.hrl", "include/amqqueue_v2.hrl"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_db_topic_exchange_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_db_topic_exchange_SUITE.erl"],
        outs = ["test/rabbit_db_topic_exchange_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_test_rabbit_event_handler_beam",
        testonly = True,
        srcs = ["test/test_rabbit_event_handler.erl"],
        outs = ["test/test_rabbit_event_handler.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "per_node_limit_SUITE_beam_files",
        testonly = True,
        srcs = ["test/per_node_limit_SUITE.erl"],
        outs = ["test/per_node_limit_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "runtime_parameters_SUITE_beam_files",
        testonly = True,
        srcs = ["test/runtime_parameters_SUITE.erl"],
        outs = ["test/runtime_parameters_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "rabbit_message_interceptor_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_message_interceptor_SUITE.erl"],
        outs = ["test/rabbit_message_interceptor_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbitmq_4_0_deprecations_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbitmq_4_0_deprecations_SUITE.erl"],
        outs = ["test/rabbitmq_4_0_deprecations_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "quorum_queue_member_reconciliation_SUITE_beam_files",
        testonly = True,
        srcs = ["test/quorum_queue_member_reconciliation_SUITE.erl"],
        outs = ["test/quorum_queue_member_reconciliation_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "message_containers_SUITE_beam_files",
        testonly = True,
        srcs = ["test/message_containers_SUITE.erl"],
        outs = ["test/message_containers_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "mc_SUITE_beam_files",
        testonly = True,
        srcs = ["test/mc_SUITE.erl"],
        outs = ["test/mc_SUITE.beam"],
        app_name = "rabbit",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp10_common:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
