defmodule KjerSi.Repo.Migrations.CreateUserChannel do
  use Ecto.Migration

  def change do
    create table(:users_channels) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :channel_id, references(:channels, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
