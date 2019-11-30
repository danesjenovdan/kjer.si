defmodule KjerSi.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :uuid, Ecto.UUID
    field :datetime, :utc_datetime
    field :description, :string
    field :max_attending, :integer
    field :name, :string
    field :author, :binary_id
    field :room_id, :binary_id

    many_to_many :users, KjerSi.Accounts.User, join_through: KjerSi.Events.UserEvent, unique: true

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :datetime, :max_attending])
    |> validate_required([:name, :description, :datetime, :max_attending])
  end
end