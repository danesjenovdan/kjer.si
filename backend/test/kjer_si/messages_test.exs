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

    def message_fixture(user_id, room_id) do
      Repo.insert!(%Message{content: "message content", user_id: user_id, room_id: room_id})
      |> KjerSi.Repo.preload([:user])
    end

    test "list_messages/3 returns a list of messages for given room_id", %{
      user_id: user_id,
      room_id: room_id
    } do
      future_date = "2100-01-01T00:00:00"
      limit = 1000
      irrelevant_room = TestHelper.generate_room()

      message1 = message_fixture(user_id, room_id)
      message2 = message_fixture(user_id, room_id)
      message_fixture(user_id, irrelevant_room.id)

      assert Messages.list_messages(room_id, future_date, limit) == [message1, message2]
    end

    test "list_messages/3 can be filtered with a `before` date", %{
      user_id: user_id,
      room_id: room_id
    } do
      past_date = "1950-01-01T00:00:00"
      limit = 1000

      message_fixture(user_id, room_id)
      message_fixture(user_id, room_id)

      assert Messages.list_messages(room_id, past_date, limit) == []
    end

    test "list_messages/3 result count can be limited with `limit` to return latest n messages",
         %{
           user_id: user_id,
           room_id: room_id
         } do
      future_date = "2100-01-01T00:00:00"
      limit = 1

      message_fixture(user_id, room_id)
      message = message_fixture(user_id, room_id)

      assert Messages.list_messages(room_id, future_date, limit) == [message]
    end
  end
end
