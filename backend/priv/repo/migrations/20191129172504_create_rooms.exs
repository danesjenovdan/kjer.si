defmodule KjerSi.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text
      add :lat, :float
      add :lng, :float
      add :radius, :integer
      add :category_id, references(:categories, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    execute("SELECT AddGeometryColumn('rooms', 'coordinates', 4326, 'POINT', 2);") # used to be srid 3857 / 4326
    create index(:rooms, [:category_id])
    create index(:rooms, [:coordinates], using: :gist)
  end
end
