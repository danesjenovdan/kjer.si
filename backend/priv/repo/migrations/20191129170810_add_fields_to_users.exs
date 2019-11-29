defmodule KjerSi.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_active, :boolean
      add :is_admin, :boolean
    end
  end
end
