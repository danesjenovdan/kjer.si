require Logger

defmodule KjerSiWeb.ChatChannel do
  use KjerSiWeb, :channel

  def join("room:" <> room_id, payload, socket) do
    if authorized?(payload) do
    Logger.info "joinal sobo #{room_id}"
    send(self(), :after_join)
    {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  def handle_in("shout", payload, socket) do
    "room:" <> room_id = socket.topic
    payload = Map.merge(payload, %{"room_id" => room_id})
    KjerSi.Messages.Message.changeset(%KjerSi.Messages.Message{}, payload) |> KjerSi.Repo.insert
    # broadcast socket, "shout", payload

    broadcast socket, "shout", payload

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_info(:after_join, socket) do
    "room:" <> room_id = socket.topic
    KjerSi.Messages.Message.get_messages_for_room(room_id)
    |> Enum.each(fn msg -> push(socket, "shout", %{
        user_id: msg.user_id,
        content: msg.content,
        room_id: msg.room_id,
      }) end)
    {:noreply, socket} # :noreply
  end
end
