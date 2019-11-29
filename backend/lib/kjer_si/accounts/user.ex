defmodule KjerSi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :uuid, :string
    field :nickname, :string
    field :is_admin, :boolean, default: false
    field :is_active, :boolean, default: true

    many_to_many :channels, KjerSi.Channels.Channel, join_through: KjerSi.Accounts.UserChannel, unique: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:nickname, :uuid])
    |> validate_required([:nickname, :uuid])
    |> unique_constraint(:nickname)
    |> unique_constraint(:uuid)
  end

  def changeset_update_channels(user, channels) do
    user
    # associate channels to the user
    |> put_assoc(:channels, channels)
  end
end
