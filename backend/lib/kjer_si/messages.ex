defmodule KjerSi.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias KjerSi.Repo

  alias KjerSi.Messages.Message

  @doc """
  Returns a list of messages for given room_id.

  ## Examples

      iex> list_messages("123", "2020-01-13T13:20:02", "20")
      [%Message{}, ...]

  """
  def list_messages(room_id, before, limit) do
    Message
    |> where([m], m.inserted_at < ^before and m.room_id == ^room_id)
    |> limit([m], ^limit)
    |> Repo.all()
    |> Repo.preload([:user])
  end
end
