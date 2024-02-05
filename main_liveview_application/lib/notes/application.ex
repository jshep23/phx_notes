defmodule Notes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NotesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Notes.PubSub},
      Supervisor.child_spec({Phoenix.PubSub, name: Remote.PubSub}, id: :remote_pubsub),
      Notes.FeatureFlagServer,
      Notes.JobScheduler,
      # Start Finch
      {Finch, name: Notes.Finch},
      # Start the Endpoint (http/https)
      NotesWeb.Endpoint
      # Start a worker by calling: Notes.Worker.start_link(arg)
      # {Notes.Worker, arg}
    ]

    IO.puts("Mix.env() = #{Mix.env()}")

    children =
      if Mix.env() == :dev_distributed do
        [
          {Cluster.Supervisor,
           [Application.get_env(:libcluster, :topologies), [name: Notes.ClusterSupervisor]]}
          | children
        ]
      else
        children
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Notes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NotesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
