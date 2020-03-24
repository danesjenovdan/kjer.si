defmodule KjerSiWeb.MessageController do
  use KjerSiWeb, :controller
  use Params

  alias KjerSi.Messages
  alias KjerSi.Rooms.Room

  action_fallback KjerSiWeb.FallbackController

  defparams message_index(%{
              room_id!: :binary_id,
              before!: :date,
              limit!: :integer
            })

  def index(conn, params) do
    changeset = message_index(params)

    if changeset.valid? do
      %{"room_id" => room_id, "before" => before, "limit" => limit} = params

      with {:ok, %Room{}} <- KjerSi.Rooms.get_room(room_id) do
        messages = Messages.list_messages(room_id, before, limit)
        render(conn, "index.json", messages: messages)
      end
    else
      {:error, changeset}
    end
  end
end
