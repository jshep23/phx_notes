defmodule NotesWeb.MenuController do
  use NotesWeb, :controller

  def index(conn, _params) do
    render(conn, :menu)
  end
end
