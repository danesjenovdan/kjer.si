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
    field :author, :binary_id
    field :channel_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :description, :datetime, :max_attending])
    |> validate_required([:name, :description, :datetime, :max_attending])
  end
end
