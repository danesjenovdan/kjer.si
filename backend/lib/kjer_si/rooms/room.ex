defmodule KjerSi.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rooms" do
    field :name, :string
    belongs_to :category, KjerSi.Rooms.Category
    field :lat, :float, virtual: true
    field :lng, :float, virtual: true
    field :coordinates, Geo.PostGIS.Geometry
    field :radius, :integer

    many_to_many :users, KjerSi.Accounts.User, join_through: KjerSi.Accounts.UserRoom, unique: true

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :lat, :lng, :radius, :category_id])
    |> cast_coordinates()
    |> validate_required([:name, :lat, :lng, :radius, :category_id])
  end

  def cast_coordinates(changeset) do
    lat = get_change(changeset, :lat)
    lng = get_change(changeset, :lng)
    geo = %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    changeset |> put_change(:coordinates, geo)
  end
end
