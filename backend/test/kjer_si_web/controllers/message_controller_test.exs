defmodule KjerSiWeb.MessageControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User
  alias KjerSi.Messages.Message

  setup %{conn: conn} do
    user = Repo.insert!(%User{nickname: "user", uid: "2", is_admin: false})
    room = TestHelper.generate_room()
    conn = TestHelper.login_user(conn, user)

    Repo.insert!(%Message{content: "message 1", room: room, user: user})
    Repo.insert!(%Message{content: "message 2", room: room, user: user})

    {:ok, conn: conn, room: room}
  end

  describe "index" do
    test "returns a list of messages for a room", %{conn: conn, room: room} do
      future_date = "2100-01-01T00:00:00"

      %{"data" => [%{"content" => "message 1"}, %{"content" => "message 2"}]} =
        conn
        |> get(Routes.room_message_path(conn, :index, room.id, before: future_date, limit: 10))
        |> json_response(200)
    end

    test "requires before param to be present", %{conn: conn, room: room} do
      %{"errors" => %{"fields" => %{"before" => ["can't be blank"]}}} =
        conn
        |> get(Routes.room_message_path(conn, :index, room.id, limit: 10))
        |> json_response(422)
    end

    test "requires before param to be a valid date", %{conn: conn, room: room} do
      invalid_date = "like, yesterday"

      %{"errors" => %{"fields" => %{"before" => ["is invalid"]}}} =
        conn
        |> get(Routes.room_message_path(conn, :index, room.id, before: invalid_date, limit: 10))
        |> json_response(422)
    end

    test "requires limit param to be present", %{conn: conn, room: room} do
      future_date = "2100-01-01T00:00:00"

      %{"errors" => %{"fields" => %{"limit" => ["can't be blank"]}}} =
        conn
        |> get(Routes.room_message_path(conn, :index, room.id, before: future_date))
        |> json_response(422)
    end

    test "requires limit param to be a valid integer", %{conn: conn, room: room} do
      future_date = "2100-01-01T00:00:00"

      %{"errors" => %{"fields" => %{"limit" => ["is invalid"]}}} =
        conn
        |> get(Routes.room_message_path(conn, :index, room.id, before: future_date, limit: "3.4"))
        |> json_response(422)
    end
  end
end
