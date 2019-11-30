defmodule KjerSi.Accounts.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "users_rooms" do
    belongs_to :user_id, KjerSi.Accounts.User
    belongs_to :room_id, KjerSi.Rooms.Room

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
  end
end
