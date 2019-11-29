defmodule KjerSi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :uuid, :string
    field :nickname, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:nickname, :uuid])
    |> validate_required([:nickname, :uuid])
    |> unique_constraint(:nickname)
    |> unique_constraint(:uuid)
  end
end
