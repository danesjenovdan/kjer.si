defmodule KjerSi.Public.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :device_id, :integer
    field :nickname, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:nickname, :device_id])
    |> validate_required([:nickname, :device_id])
    |> unique_constraint(:nickname)
    |> unique_constraint(:device_id)
  end
end
