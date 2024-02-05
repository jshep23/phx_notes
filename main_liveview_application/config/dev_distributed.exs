import Config

import_config "dev.exs"

config :libcluster,
  topologies: [
    local: [
      strategy: Cluster.Strategy.LocalEpmd,
      config: [hosts: [:"feature_flags_service@127.0.0.1"]],
      connect: {:net_kernel, :connect_node, []},
      disconnect: {:erlang, :disconnect_node, []},
      list_nodes: {:erlang, :nodes, [:connected]}
    ]
  ]

config :notes, :feature_flag_repo, Notes.Repository.FeatureFlagDistributedRepo
config :notes, :feature_flag_pub_sub, Remote.PubSub
config :notes, :feature_flag_source, :remote
