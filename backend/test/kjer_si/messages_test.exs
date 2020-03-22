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
      _message1 = message_fixture(user_id, room_id)
      _message2 = message_fixture(user_id, room_id)
      a_long_time_ago = "1986-04-26T01:23:40+0400"

      assert Messages.list_messages(a_long_time_ago) == []
    end

    test "list_messages accepts limit as second argument", %{user_id: user_id, room_id: room_id} do
      message1 = message_fixture(user_id, room_id)
      _message2 = message_fixture(user_id, room_id)
      assert Messages.list_messages(nil, 1) == [message1]
    end

    test "get_message!/1 returns the message with given id", %{user_id: user_id, room_id: room_id} do
      message = message_fixture(user_id, room_id)
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message", %{
      user_id: user_id,
      room_id: room_id
    } do
      assert {:ok, %Message{} = message} =
               Messages.create_message(%{
                 user_id: user_id,
                 room_id: room_id,
                 content: "some content"
               })

      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message", %{
      user_id: user_id,
      room_id: room_id
    } do
      message = message_fixture(user_id, room_id)
      assert {:ok, %Message{} = message} = Messages.update_message(message, @update_attrs)
      assert message.content == "some updated content"
    end

    test "update_message/2 with invalid data returns error changeset", %{
      user_id: user_id,
      room_id: room_id
    } do
      message = message_fixture(user_id, room_id)
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message", %{user_id: user_id, room_id: room_id} do
      message = message_fixture(user_id, room_id)
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset", %{user_id: user_id, room_id: room_id} do
      message = message_fixture(user_id, room_id)
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
