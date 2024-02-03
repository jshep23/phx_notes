defmodule Notes.AtomType do
  @behaviour Ecto.Type

  def type, do: :string

  def cast(atom) when is_atom(atom), do: {:ok, Atom.to_string(atom)}
  def cast(string) when is_binary(string), do: {:ok, String.to_atom(string)}

  def load(string) when is_binary(string), do: {:ok, String.to_atom(string)}
  def dump(atom) when is_atom(atom), do: {:ok, Atom.to_string(atom)}

  def equal?(first, second), do: first == second

  def embed_as(_), do: :dump
end
