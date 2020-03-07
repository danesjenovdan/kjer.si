defmodule KjerSiWeb.RoomControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User
  alias KjerSi.Rooms.Room
  alias KjerSi.Rooms.Category

  setup %{conn: conn} do
    admin = Repo.insert!(%User{nickname: "admin", uid: "1", is_admin: true})
    user = Repo.insert!(%User{nickname: "user", uid: "2", is_admin: false})
    category = Repo.insert!(%Category{name: "Test category"})

    room =
      Repo.insert!(%Room{name: "Test room", category: category, lat: 10.0, lng: 2.0, radius: 10})

    {:ok, conn: conn, room: room, admin: admin, user: user, category: category}
  end

  defp login_user(conn, user) do
    token = Phoenix.Token.sign(KjerSiWeb.Endpoint, "user auth", user.id)
    put_req_header(conn, "authorization", "Bearer #{token}")
  end

  describe "create" do
    test "regular user can create a room", %{conn: conn, user: user, category: category} do
      %{"name" => "New room", "radius" => 5} =
        conn
        |> login_user(user)
        |> post(
          Routes.room_path(conn, :create),
          room: %{name: "New room", lat: 10.1, lng: 2.3, radius: 5, category_id: category.id}
        )
        |> json_response(201)
    end
  end

  describe "delete" do
    test "regular user can't delete a room", %{conn: conn, user: user, room: room} do
      conn
      |> login_user(user)
      |> delete(Routes.admin_room_path(conn, :delete, room))
      |> json_response(403)
    end

    test "admin can delete a room", %{conn: conn, admin: admin, room: room} do
      conn
      |> login_user(admin)
      |> delete(Routes.admin_room_path(conn, :delete, room))
      |> response(204)
    end
  end

  describe "index" do
    test "regular user can't list all rooms", %{conn: conn, user: user} do
      conn
      |> login_user(user)
      |> get(Routes.admin_room_path(conn, :index))
      |> json_response(403)
    end

    test "admin can list all rooms", %{conn: conn, admin: admin} do
      %{"data" => [%{"lat" => 10.0, "lng" => 2.0}]} =
        conn
        |> login_user(admin)
        |> get(Routes.admin_room_path(conn, :index))
        |> json_response(200)
    end
  end

  describe "categories" do
    test "any user can list room categories", %{conn: conn, user: user} do
      %{"categories" => [%{"name" => "Test category"}]} =
        conn
        |> login_user(user)
        |> get(Routes.room_path(conn, :categories))
        |> json_response(200)
    end
  end
end
