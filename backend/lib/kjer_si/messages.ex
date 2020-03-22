defmodule KjerSi.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias KjerSi.Repo

  alias KjerSi.Messages.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages(before \\ nil, limit \\ nil) do
    query = Message

    query =
      if before do
        where(query, [m], m.inserted_at < ^before)
      else
        query
      end

    query =
      if limit do
        limit(query, [m], ^limit)
      else
        query
      end

    Repo.all(query)
  end
end
