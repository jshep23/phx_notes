defmodule Notes.Domain.Note do
  @moduledoc """
  Although we are not using a database,
  Ecto can still be used to handle domain validation
  and provide compile time type checking.
  """
  alias Ecto.Changeset
  alias Notes.AtomType
  alias Notes.Domain.NoteType
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :title, :string
    field :body, :string
    field :type, AtomType, default: :todo
  end

  def changeset(note, params \\ %{}) do
    note
    |> cast(params, [:title, :body, :type])
    |> validate_required([:title, :body], message: "Required")
    |> validate_inclusion(:type, NoteType.values(), message: "Invalid type")
  end

  def from_changeset(changeset) do
    Changeset.apply_changes(changeset)
  end

  def todos(notes) when is_list(notes) do
    Enum.filter(notes, &(&1.type == :todo))
  end

  def events(notes) when is_list(notes) do
    Enum.filter(notes, &(&1.type == :event))
  end

  def reminders(notes) when is_list(notes) do
    Enum.filter(notes, &(&1.type == :reminder))
  end
end
