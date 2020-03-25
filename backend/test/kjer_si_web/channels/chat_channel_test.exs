defmodule KjerSiWeb.ChatChannelTest do
  use KjerSiWeb.ChannelCase

  setup do
    test_room = TestHelper.generate_room()
    test_user = TestHelper.generate_user()

    {:ok, _, socket} =
      socket(KjerSiWeb.UserSocket, "user_id", %{user_id: test_user.id})
      |> subscribe_and_join(KjerSiWeb.ChatChannel, "room:" <> test_room.id)

    {:ok, socket: socket, user_id: test_user.id, user_nickname: test_user.nickname, room_id: test_room.id}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to chat:lobby", %{socket: socket, user_id: user_id, user_nickname: user_nickname, room_id: room_id} do
    push socket, "shout", %{:content => "test chat message"}
    assert_broadcast "shout", %{
      content: "test chat message",
      created: _,
      id: _,
      roomId: ^room_id,
      userId: ^user_id,
      userNickname: ^user_nickname,
    }
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
