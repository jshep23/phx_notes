defmodule Notes.Domain.NoteType do
  @type t :: :todo | :event | :reminder

  def values, do: [:todo, :event, :reminder]

  def is_valid?(value), do: value in values()
end
