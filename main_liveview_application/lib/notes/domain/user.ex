defmodule Notes.Domain.User do
  alias Ecto.Changeset
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
  end

  def full_name(user), do: "#{user.first_name} #{user.last_name}"

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email], message: "Required")
  end

  def from_changeset(changeset) do
    Changeset.apply_changes(changeset)
  end
end
