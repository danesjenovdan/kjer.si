require Logger

defmodule KjerSiWeb.ChatChannel do
  use KjerSiWeb, :channel

  defp render_message(message) do
    KjerSiWeb.MessageView.render("message.json", %{message: message})
  end

  def join("room:" <> _room_id, _payload, socket) do
    if authorized?(socket.assigns.user_id) do
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
    # Parse room ID from topic
    "room:" <> room_id = socket.topic

    # Get user ID from socket
    user_id = socket.assigns.user_id

    # Merge with incoming payload and save to DB
    payload = Map.merge(payload, %{"room_id" => room_id, "user_id" => user_id})

    {:ok, message} =
      KjerSi.Messages.Message.changeset(%KjerSi.Messages.Message{}, payload)
      |> KjerSi.Repo.insert()

    message = KjerSi.Repo.preload(message, :user)

    # Broadcast back to everyone in the channel
    broadcast(socket, "shout", render_message(message))

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_info(:after_join, socket) do
    {:noreply, socket}
  end
end
