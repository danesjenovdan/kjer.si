defmodule KjerSi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nickname, :string, null: false
      add :device_id, :integer, null: false

      timestamps()
    end

    create unique_index(:users, [:nickname])
    create unique_index(:users, [:device_id])
  end
end
