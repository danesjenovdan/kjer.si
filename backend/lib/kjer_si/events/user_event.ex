defmodule KjerSi.Events.UserEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users_events" do
    belongs_to :user, KjerSi.Accounts.User
    belongs_to :event, KjerSi.Events.Event

    timestamps()
  end

  @doc false
  def changeset(event, params \\ %{}) do
    event
    |> cast(params, [:user_id, :event_id])
    |> validate_required([:user_id, :event_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:event_id)
    |> unique_constraint(:user, name: :user_id_event_id_unique)
  end
end
