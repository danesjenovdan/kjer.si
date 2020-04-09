defmodule KjerSi.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rooms" do
    field :name, :string
    belongs_to :category, KjerSi.Rooms.Category
    field :lat, :float
    field :lng, :float
    field :coordinates, Geo.PostGIS.Geometry
    field :radius, :integer
    field :description, :string
    has_many :events, KjerSi.Events.Event

    many_to_many :users, KjerSi.Accounts.User,
      join_through: KjerSi.Accounts.Subscription,
      unique: true

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :category_id, :lat, :lng, :radius, :description])
    |> cast_coordinates()
    |> validate_required([:name, :category_id, :lat, :lng, :radius, :coordinates, :description])
  end

  def cast_coordinates(changeset) do
    lat = get_change(changeset, :lat)
    lng = get_change(changeset, :lng)
    point = %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    changeset |> put_change(:coordinates, point)
  end
end
