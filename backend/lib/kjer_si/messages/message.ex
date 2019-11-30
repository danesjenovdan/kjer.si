defmodule KjerSi.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string
    belongs_to :room, KjerSi.Rooms.Room
    belongs_to :user, KjerSi.Accounts.User

    timestamps()
  end


  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :room_id, :user_id])
    |> validate_required([:content, :room_id, :user_id])
  end
end
