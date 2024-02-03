defmodule NotesWeb.AddNoteForm do
  alias Notes.Domain.NoteType
  use NotesWeb, :live_component
  import NotesWeb.CoreComponents
  use NotesWeb.ValidatingForm

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form}>
        <.input label="Title" name="title" field={@form[:title]} />
        <.input label="Body" name="body" field={@form[:body]} />
        <.input
          type="select"
          label="Type"
          name="type"
          field={@form[:type]}
          options={NoteType.values()}
        />
      </.simple_form>
    </div>
    """
  end

  def update(%{on_save: onSave, form: form}, socket) do
    {:ok, assign(socket, form: form, onSave: onSave)}
  end
end
