defmodule KjerSiWeb.MessageController do
  use KjerSiWeb, :controller
  use Params

  alias KjerSi.Messages

  action_fallback KjerSiWeb.FallbackController

  defparams message_index(%{
              before!: :date,
              limit!: :integer
            })

  def index(conn, params) do
    changeset = message_index(params)

    if changeset.valid? do
      messages =
        Messages.list_messages(params["before"], params["limit"])
        |> KjerSi.Repo.preload([:user])

      conn
      |> render("index.json", messages: messages)
    else
      {:error, changeset}
    end
  end
end
