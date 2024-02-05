defmodule NotesWeb.UserNotesLive do
  alias Notes.Domain.Note
  alias Notes.Domain.NoteType
  use NotesWeb, :live_view
  import Notes.PubSub
  use NotesWeb.ValidatingForm
  alias Notes.Domain.User
  use Notes.PubSub.Topics.NotesTopics
  import NotesWeb.CoreComponents
  import NotesWeb.StickyNote
  import NotesWeb.Dialogs

  def render(assigns) do
    ~H"""
    <div>
      <div class="mx-auto font-bold text-2xl text-center pb-5">
        <%= User.full_name(@user) %>'s Notes
      </div>

      <div class="flex justify-center items-center m-5">
        <.button phx-click="open_add_note_dialog" class="text-white font-bold py-2 px-4 rounded">
          Add Note
        </.button>
        <.button phx-click="change_user" class="ml-5">
          Change User
        </.button>
      </div>

      <%= if !Enum.empty?(@notes) do %>
        <div class="grid grid-cols-3 gap-3 text-center">
          <.label :for={type <- NoteType.values()}>
            <%= to_column_label(type) %>
          </.label>
        </div>

        <div class="grid grid-cols-3 gap-3">
          <div>
            <div :for={note <- Note.todos(@notes)} class="my-4">
              <%= to_note(note) %>
            </div>
          </div>

          <div>
            <div :for={note <- Note.events(@notes)} class="my-4">
              <%= to_note(note) %>
            </div>
          </div>

          <div>
            <div :for={note <- Note.reminders(@notes)} class="my-4">
              <%= to_note(note) %>
            </div>
          </div>
        </div>
      <% else %>
        <div class="text-center">
          No notes found
        </div>
      <% end %>

      <.dialog :if={@add_note_form}>
        <:title>
          Add Note
        </:title>
        <:body>
          <.simple_form for={@add_note_form} phx-submit="save_note" phx-change="validate_note">
            <.input label="Title" name="title" field={@add_note_form[:title]} />
            <.input label="Body" name="body" field={@add_note_form[:body]} />
            <.input
              type="select"
              label="Type"
              name="type"
              field={@add_note_form[:type]}
              options={NoteType.values()}
            />
            <:actions>
              <.button type="submit">Save</.button>
              <.button phx-click="close_add_note_dialog">Cancel</.button>
            </:actions>
          </.simple_form>
        </:body>
      </.dialog>
    </div>
    """
  end

  def mount(_, session, socket) do
    {:ok, assign(socket, notes: [], user: session["user"], add_note_form: nil)}
  end

  def handle_event("change_user", _, socket) do
    publish(@change_user_topic)
    {:noreply, socket}
  end

  def handle_event("open_add_note_dialog", _, socket) do
    add_note_form =
      %Note{}
      |> Note.changeset()
      |> with_validation()
      |> to_form()

    {:noreply, assign(socket, add_note_form: add_note_form)}
  end

  def handle_event("close_add_note_dialog", _, socket) do
    {:noreply, assign(socket, add_note_form: nil)}
  end

  def handle_event("validate_note", params, socket) do
    add_note_form =
      %Note{}
      |> Note.changeset(params)
      |> with_validation()
      |> to_form()

    {:noreply, assign(socket, add_note_form: add_note_form)}
  end

  def handle_event("save_note", params, socket) do
    note =
      %Note{}
      |> Note.changeset(params)

    if note.valid? do
      {:noreply,
       socket
       |> assign(
         add_note_form: nil,
         notes: [note |> Note.from_changeset() | socket.assigns.notes]
       )}
    else
      {:noreply, socket}
    end
  end

  defp to_column_label(type) do
    (type |> Atom.to_string() |> String.capitalize()) <> "'s"
  end

  defp to_note(%Note{type: type} = note) do
    case type do
      :todo -> yellow_note(%{text: note.body, title: note.title})
      :event -> blue_note(%{text: note.body, title: note.title})
      :reminder -> green_note(%{text: note.body, title: note.title})
    end
  end
end
