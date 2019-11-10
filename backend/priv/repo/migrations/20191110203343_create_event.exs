defmodule KjerSi.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:event, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :limited, :boolean, default: false, null: false
      add :description, :text
      add :datetime, :naive_datetime
      add :number_of_seats, :integer
      add :is_attendance, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:event, [:title])
  end
end
