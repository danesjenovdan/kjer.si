defmodule KjerSiWeb.SubscriptionControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.Subscription

  setup %{conn: conn} do
    user = TestHelper.generate_user()
    room = TestHelper.generate_room()
    conn = TestHelper.login_user(conn, user)

    subscription = Repo.insert!(%Subscription{user: user, room: room})

    {:ok, conn: conn, user: user, subscription: subscription, room: room}
  end

  describe "index" do
    test "returns a list of subscriptions for logged in user", %{
      conn: conn,
      subscription: subscription
    } do
      subscription_id = subscription.id

      %{"data" => [%{"id" => ^subscription_id}]} =
        conn
        |> get(Routes.subscription_path(conn, :index))
        |> json_response(200)
    end
  end

  describe "create" do
    test "user can subscribe themselves to a room", %{conn: conn, user: user} do
      new_room = TestHelper.generate_room()
      new_room_id = new_room.id
      user_id = user.id

      %{"data" => %{"roomId" => ^new_room_id, "userId" => ^user_id}} =
        conn
        |> post(Routes.subscription_path(conn, :create), room_id: new_room_id)
        |> json_response(201)
    end

    test "user-room relationships must be unique", %{conn: conn, subscription: subscription} do
      already_subscribed_room_id = subscription.room_id

      %{"errors" => %{"fields" => %{"user" => ["has already been taken"]}}} =
        conn
        |> post(Routes.subscription_path(conn, :create), room_id: already_subscribed_room_id)
        |> json_response(422)
    end
  end

  describe "delete" do
    test "user can unsubscribe themselves from a room", %{conn: conn, subscription: subscription} do
      existing_subscription_id = subscription.id

      "" =
        conn
        |> delete(Routes.subscription_path(conn, :delete, existing_subscription_id))
        |> response(204)
    end

    test "last user unsubscribing also deletes the room", %{
      conn: conn,
      subscription: subscription
    } do
      rooms_before = KjerSi.Rooms.list_rooms()
      assert length(rooms_before) == 1

      existing_subscription_id = subscription.id
      delete(conn, Routes.subscription_path(conn, :delete, existing_subscription_id))

      rooms_after = KjerSi.Rooms.list_rooms()
      assert length(rooms_after) == 0
    end
  end

  describe "delete_by_room_id" do
    test "finds subscription id and redirects to normal delete", %{
      conn: conn,
      subscription: subscription,
      room: room
    } do
      conn = delete(conn, Routes.room_subscription_path(conn, :delete_by_room_id, room.id))
      assert redirected_to(conn, 307) == "/api/subscriptions/#{subscription.id}"
    end

    test "fails if no subscription matches current user id and passed room_id", %{conn: conn} do
      fake_id = "ba294533-82b6-4cbb-abc1-167cd7bf4bb1"

      %{"errors" => %{"detail" => "Not Found"}} =
        conn
        |> delete(Routes.room_subscription_path(conn, :delete_by_room_id, fake_id))
        |> json_response(404)
    end
  end
end
