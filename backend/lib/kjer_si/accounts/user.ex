defmodule KjerSi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :uid, :string
    field :nickname, :string
    field :is_admin, :boolean, default: false
    field :is_active, :boolean, default: true

    many_to_many :rooms, KjerSi.Rooms.Room, join_through: KjerSi.Accounts.Subscription, unique: true
    many_to_many :events, KjerSi.Events.Event, join_through: KjerSi.Events.UserEvent, unique: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:nickname, :uid, :is_active])
    |> validate_required([:nickname, :uid])
    |> unique_constraint(:nickname)
    |> unique_constraint(:uid)
  end
end
