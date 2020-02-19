defmodule KjerSi.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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

  def get_messages_for_room(room_id) do
    query = from m in KjerSi.Messages.Message,
      where: m.room_id == ^room_id,
      order_by: [asc: m.inserted_at],
      preload: [:user]
    KjerSi.Repo.all(query)
  end
end
