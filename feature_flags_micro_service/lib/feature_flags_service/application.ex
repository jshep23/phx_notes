defmodule FeatureFlagsService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FeatureFlagsServiceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FeatureFlagsService.PubSub},
      Supervisor.child_spec({Phoenix.PubSub, name: Remote.PubSub}, id: :remote_pubsub),
      FeatureFlagsService.Flags,
      # Start the Endpoint (http/https)
      FeatureFlagsServiceWeb.Endpoint
      # Start a worker by calling: FeatureFlagsService.Worker.start_link(arg)
      # {FeatureFlagsService.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FeatureFlagsService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FeatureFlagsServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
