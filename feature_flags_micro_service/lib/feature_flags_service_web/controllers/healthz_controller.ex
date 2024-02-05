defmodule FeatureFlagsServiceWeb.HealthzController do
  use FeatureFlagsServiceWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: "ok"})
  end
end
