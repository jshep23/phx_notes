defmodule NotesWeb.Notes.IndexLive do
  alias NotesWeb.UserDetailsLive
  alias NotesWeb.UserNotesLive
  alias Notes.Domain.User
  use NotesWeb, :live_view
  use NotesWeb.ValidatingForm
  use NotesWeb.PubSub

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

    {:ok, assign(socket, user: nil)}
  end

  def handle_info(%User{} = user, socket) do
    {:noreply, assign(socket, user: user)}
  end

  def handle_info(@change_user_topic, socket) do
    {:noreply, assign(socket, user: nil)}
  end
end
