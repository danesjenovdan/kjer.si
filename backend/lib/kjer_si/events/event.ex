defmodule KjerSi.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :datetime, :utc_datetime
    field :description, :string
    field :max_attending, :integer
    field :name, :string
    belongs_to :user, KjerSi.Accounts.User
    belongs_to :room, KjerSi.Rooms.Room

    many_to_many :users, KjerSi.Accounts.User, join_through: KjerSi.Events.UserEvent, unique: true

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:datetime, :description, :max_attending, :name, :user_id, :room_id])
    |> validate_required([:datetime, :description, :max_attending, :name, :user_id, :room_id])
  end
end