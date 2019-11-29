defmodule KjerSi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nickname, :string, null: false
      add :uuid, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:nickname])
    create unique_index(:users, [:uuid])
  end
end
