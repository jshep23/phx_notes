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

  def announce_self(conn, _params) do
    send_to_all_nodes("feature_flags_service:status", %{
      "service" => "feature_flags",
      "status" => "available"
    })

    put_format(conn, "text/plain")
    |> text("Ok")
  end
end
