defmodule KjerSiWeb.UserSocketTest do
  use KjerSiWeb.ChannelCase
  alias KjerSiWeb.UserSocket

  setup do
    user = TestHelper.generate_user()

    {:ok, user: user}
  end

  test "authenticating with valid token succeeds and assigns user_id", %{user: user} do
    token = Phoenix.Token.sign(KjerSiWeb.Endpoint, "user auth", user.id)

    assert {:ok, socket} = connect(UserSocket, %{"token" => token})
    assert socket.assigns.user_id == user.id
  end

  test "authenticating with invalid token fails" do
    assert :error = connect(UserSocket, %{"token" => "invalid-token"})
  end
end
