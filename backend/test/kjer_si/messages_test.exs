defmodule KjerSi.MessagesTest do
  use KjerSi.DataCase

  alias KjerSi.Messages

  setup do
    test_room = TestHelper.generate_room()
    test_user = TestHelper.generate_user()

    {:ok, user_id: test_user.id, room_id: test_room.id}
  end

  describe "messages" do
    alias KjerSi.Messages.Message

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def message_fixture(attrs \\ %{}, user_id, room_id) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.merge(%{
          user_id: user_id,
          room_id: room_id
        })
        |> Messages.create_message()

      message
    end

    test "list_messages returns all messages by default", %{user_id: user_id, room_id: room_id} do
      message1 = message_fixture(user_id, room_id)
      message2 = message_fixture(user_id, room_id)
      assert Messages.list_messages() == [message1, message2]
    end

    test "list_messages accepts 'before' as first argument", %{user_id: user_id, room_id: room_id} do
      message_fixture(user_id, room_id)
      message_fixture(user_id, room_id)
      a_long_time_ago = "1986-04-26T01:23:40+0400"

      assert Messages.list_messages(a_long_time_ago) == []
    end

    test "list_messages accepts 'limit' as second argument", %{user_id: user_id, room_id: room_id} do
      message = message_fixture(user_id, room_id)
      message_fixture(user_id, room_id)
      assert Messages.list_messages(nil, 1) == [message]
    end
end
