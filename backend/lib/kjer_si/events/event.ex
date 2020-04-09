defmodule KjerSi.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :name, :string
    field :datetime, :utc_datetime
    field :location, :string
    field :description, :string
    field :max_attending, :integer
    belongs_to :user, KjerSi.Accounts.User
    belongs_to :room, KjerSi.Rooms.Room

    many_to_many :users, KjerSi.Accounts.User, join_through: KjerSi.Events.UserEvent, unique: true

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :datetime, :location, :description, :max_attending, :user_id, :room_id])
    |> validate_required([
      :name,
      :datetime,
      :location,
      :description,
      :max_attending,
      :user_id,
      :room_id
    ])
  end

  @doc false
  def changesetUpdate(event, attrs) do
    event
    |> cast(attrs, [:name, :location, :description, :max_attending])
    |> validate_required([:name, :location, :description, :max_attending])
  end
end
