defmodule KjerSi.Repo.Migrations.CreateUserEvents do
  use Ecto.Migration

  def change do
    create table(:users_events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :event_id, references(:events, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:users_events, [:user_id])
    create index(:users_events, [:event_id])

    create(
      unique_index(:users_events, [:user_id, :event_id], name: :user_id_event_id_unique)
    )

  end
end
