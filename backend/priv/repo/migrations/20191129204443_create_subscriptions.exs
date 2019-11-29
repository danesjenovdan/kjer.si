defmodule KjerSi.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:user_channel, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), primary_key: true
      add :channel_id, references(:channels, on_delete: :delete_all, type: :binary_id), primary_key: true

      timestamps()
    end

    create index(:user_channel, [:user_id])
    create index(:user_channel, [:channel_id])

    create(
      unique_index(:user_channel, [:user_id, :channel_id], name: :user_id_channel_id_unique_index)
    )
  end
end
