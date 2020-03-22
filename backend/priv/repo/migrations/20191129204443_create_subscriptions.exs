defmodule KjerSi.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do

    create table(:subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :room_id, references(:rooms, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create(index(:subscriptions, [:user_id]))
    create(index(:subscriptions, [:room_id]))

    create(
      unique_index(:subscriptions, [:user_id, :room_id], name: :user_id_room_id_unique_index)
    )
  end
end
