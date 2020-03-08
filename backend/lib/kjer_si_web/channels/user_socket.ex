defmodule KjerSiWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", KjerSiWeb.ChatChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket, _connect_info) do
    case KjerSi.AccountsHelpers.get_user(token) do
      {:ok, user} ->
        {:ok, assign(socket, :user_id, user.id)}

      {:error, _} ->
        # We could get a more precise error message here with:
        # KjerSi.AccountsHelpers.get_error_from_type(error_type)
        # But the docs say we can't return more than :error.
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     KjerSiWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
