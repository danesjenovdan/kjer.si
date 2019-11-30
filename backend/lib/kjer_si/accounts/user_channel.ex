defmodule KjerSi.Accounts.UserChannel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "users_channels" do
    belongs_to :user_id, KjerSi.Accounts.User
    belongs_to :channel_id, KjerSi.Channels.Channel

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :channel_id])
    |> validate_required([:user_id, :channel_id])
  end
end
