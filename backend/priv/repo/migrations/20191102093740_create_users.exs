defmodule KjerSi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nickname, :string, null: false
      add :uid, :string, null: false
      add :is_active, :boolean
      add :is_admin, :boolean

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:users, [:nickname])
    create unique_index(:users, [:uid])
  end
end
