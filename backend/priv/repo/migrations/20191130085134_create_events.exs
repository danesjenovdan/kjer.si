defmodule KjerSi.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :datetime, :utc_datetime
      add :max_attending, :integer
      add :author, references(:users, on_delete: :nothing, type: :binary_id)
      add :room_id, references(:rooms, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:events, [:author])
    create index(:events, [:room_id])
  end
end