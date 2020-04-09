defmodule KjerSiWeb.RoomControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User

  setup %{conn: conn} do
    user = Repo.insert!(%User{nickname: "user", uid: "2", is_admin: false})
    room = TestHelper.generate_room()

    conn = TestHelper.login_user(conn, user)

    {:ok, conn: conn, room: room}
  end

  describe "index" do
    test "returns a list of rooms near a point", %{conn: conn} do
      %{"data" => [%{"name" => "Test room", "lat" => 120.5, "lng" => 121.4}]} =
        conn
        |> get(Routes.room_path(conn, :index, lat: "120.5", lng: "121.4"))
        |> json_response(200)

      %{"data" => []} =
        conn
        |> get(Routes.room_path(conn, :index, lat: "120.501", lng: "3"))
        |> json_response(200)
    end

    test "requires lng param to be present", %{conn: conn} do
      %{"errors" => %{"fields" => %{"lng" => ["can't be blank"]}}} =
        conn
        |> get(Routes.room_path(conn, :index, lat: "120.501"))
        |> json_response(422)
    end

    test "requires lng param to be a valid float", %{conn: conn} do
      %{"errors" => %{"fields" => %{"lng" => ["is invalid"]}}} =
        conn
        |> get(Routes.room_path(conn, :index, lat: "120.501", lng: "two"))
        |> json_response(422)
    end

    test "requires lat param to be present", %{conn: conn} do
      %{"errors" => %{"fields" => %{"lat" => ["can't be blank"]}}} =
        conn
        |> get(Routes.room_path(conn, :index, lng: "121.401"))
        |> json_response(422)
    end

    test "requires lat param to be a valid float", %{conn: conn} do
      %{"errors" => %{"fields" => %{"lat" => ["is invalid"]}}} =
        conn
        |> get(Routes.room_path(conn, :index, lng: "121.401", lat: true))
        |> json_response(422)
    end
  end

  describe "show" do
    test "regular user get room details", %{conn: conn, room: room} do
      %{"data" => %{"name" => "Test room", "radius" => 42}} =
        conn
        |> get(Routes.room_path(conn, :show, room.id))
        |> json_response(200)
    end
  end

  describe "create" do
    test "regular user can create a room", %{conn: conn} do
      category = TestHelper.generate_category()

      %{"data" => %{"name" => "New room", "radius" => 5}} =
        conn
        |> post(
          Routes.room_path(conn, :create),
          %{
            name: "New room",
            description: "room description",
            lat: 10.1,
            lng: 2.3,
            radius: 5,
            category_id: category.id
          }
        )
        |> json_response(201)
    end
  end
end
