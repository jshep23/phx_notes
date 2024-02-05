defmodule NotesWeb.MenuController do
  use NotesWeb, :controller

  def index(conn, _params) do
    render(conn, :menu, feature_flag_source: Application.get_env(:notes, :feature_flag_source))
  end
end
