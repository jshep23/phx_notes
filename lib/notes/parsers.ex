defmodule Notes.Parsers do
  def parse_boolean("true"), do: true
  def parse_boolean("false"), do: false
  def parse_boolean(_), do: raise("Invalid boolean")
end
