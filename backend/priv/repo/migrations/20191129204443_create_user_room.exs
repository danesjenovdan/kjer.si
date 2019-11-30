defmodule KjerSi.Repo.Migrations.CreateUserRooms do
  use Ecto.Migration

  def change do
    create table(:users_rooms) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :room_id, references(:rooms, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
