defmodule KjerSi.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "event" do
    field :datetime, :naive_datetime
    field :description, :string
    field :is_attendance, :boolean, default: false
    field :limited, :boolean, default: false
    field :number_of_seats, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :limited, :description, :datetime, :number_of_seats, :is_attendance])
    |> validate_required([:title, :limited, :description, :datetime, :number_of_seats, :is_attendance])
    |> unique_constraint(:title)
  end
end
