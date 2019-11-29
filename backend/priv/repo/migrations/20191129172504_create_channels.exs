defmodule KjerSi.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text
      # add :lat, :float
      # add :lng, :float
      add :uuid, :uuid
      add :radius, :integer
      add :category_id, references(:categories, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    execute("SELECT AddGeometryColumn ('channels','coordinates',4326,'POINT',2);")
    create index(:channels, [:category_id])
  end
end
