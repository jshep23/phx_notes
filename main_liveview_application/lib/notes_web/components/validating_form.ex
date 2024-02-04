defmodule NotesWeb.ValidatingForm do
  defmacro __using__(_opts) do
    quote do
      def with_validation(changeset), do: changeset |> Map.put(:action, :validate)
    end
  end
end
