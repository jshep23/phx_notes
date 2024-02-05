defmodule NotesWeb.Notes.IndexLive do
  require Logger
  alias NotesWeb.UserDetailsLive
  alias NotesWeb.UserNotesLive
  alias Notes.Domain.User
  use NotesWeb, :live_view
  use NotesWeb.ValidatingForm
  use Notes.PubSub

  def render(assigns) do
    ~H"""
    <div>
      <%= if @user do %>
        <%= live_render(@socket, UserNotesLive, session: %{"user" => @user}, id: "user-notes") %>
      <% else %>
        <%= live_render(@socket, UserDetailsLive, id: "user-details") %>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    subscribe([@user_created_topic, @change_user_topic])
    subscribe(:system, "feature_flags_service:status")

    log_connected_nodes()

    {:ok, assign(socket, user: nil)}
  end

  def handle_info(%{"service" => "feature_flags", "status" => status}, socket) do
    {:noreply, socket |> put_flash(:info, "Feature Flags Service: #{status}")}
  end

  def handle_info(%User{} = user, socket) do
    {:noreply, assign(socket, user: user)}
  end

  def handle_info(@change_user_topic, socket) do
    {:noreply, assign(socket, user: nil)}
  end

  def log_connected_nodes do
    Logger.info("Logging connected nodes")
    # Node.connect(:"feature_flags_service@127.0.0.1")

    Node.list()
    |> Enum.each(fn node ->
      Logger.info("Connected to node: #{inspect(node)}")
    end)
  end
end
