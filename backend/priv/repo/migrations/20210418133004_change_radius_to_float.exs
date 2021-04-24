defmodule KjerSi.Repo.Migrations.ChangeRadiusToFloat do
  use Ecto.Migration

  def change do
    alter table("rooms") do
      modify :radius, :float
    end
  end
end
