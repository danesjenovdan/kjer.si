defmodule KjerSi.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
<<<<<<< HEAD
      add :datetime, :utc_datetime
      add :location, :string
      add :description, :string
      add :max_attending, :integer
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :room_id, references(:rooms, on_delete: :nothing, type: :binary_id)
=======
      add :description, :string
      add :datetime, :utc_datetime
      add :max_attending, :integer
      add :author, references(:users, on_delete: :nothing, type: :binary_id)
      add :channel_id, references(:channels, on_delete: :nothing, type: :binary_id)
>>>>>>> 3d458a62738855956ff32c424c1eaf0462e31d1b

      timestamps()
    end

<<<<<<< HEAD
    create index(:events, [:user_id])
    create index(:events, [:room_id])
  end
end
=======
    create index(:events, [:author])
    create index(:events, [:channel_id])
  end
end
>>>>>>> 3d458a62738855956ff32c424c1eaf0462e31d1b
