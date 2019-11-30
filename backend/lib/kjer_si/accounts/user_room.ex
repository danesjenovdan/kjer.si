defmodule KjerSi.Accounts.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users_rooms" do
    belongs_to :user, KjerSi.Accounts.User
    belongs_to :room, KjerSi.Rooms.Room

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:room_id)
    |> unique_constraint(:user, name: :user_id_room_id_unique_index)
  end
end
