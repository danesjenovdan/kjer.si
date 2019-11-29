defmodule KjerSi.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "channels" do
    field :uuid, Ecto.UUID
    field :name, :string
    field :category_id, :binary_id
    field :lat, :float, virtual: true
    field :lng, :float, virtual: true
    field :coordinates, Geo.PostGIS.Geometry
    field :radius, :integer

    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :lat, :lng, :uuid, :radius])
    |> validate_required([:name, :lat, :lng, :uuid, :radius])
    |> cast_coordinates()
  end

  def cast_coordinates(changeset) do
    lat = get_change(changeset, :lat)
    lng = get_change(changeset, :lng)
    geo = %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    changeset |> put_change(:coordinates, geo)
  end
end
