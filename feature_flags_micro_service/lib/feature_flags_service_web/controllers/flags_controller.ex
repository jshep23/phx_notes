defmodule FeatureFlagsServiceWeb.FlagsController do
  use FeatureFlagsServiceWeb, :controller
  use FeatureFlagsService.PubSub
  alias FeatureFlagsService.Flags

  def get_all(conn, _params) do
    flags = Flags.get_feature_flags()
    json(conn, %{flags: flags})
  end

  def toggle(conn, %{"name" => name}) do
    Flags.toggle_feature_flag(name)
    json(conn, %{status: "ok"})
  end

  def add(conn, %{"name" => _name, "enabled" => _enabled} = flag) do
    Flags.add_feature_flag(flag)
    json(conn, %{status: "ok"})
  end
end
