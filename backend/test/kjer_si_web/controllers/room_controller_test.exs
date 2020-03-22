defmodule KjerSiWeb.RoomControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User
  alias KjerSi.Rooms.Room
  alias KjerSi.Rooms.Category

  setup %{conn: conn} do
    user = Repo.insert!(%User{nickname: "user", uid: "2", is_admin: false})
    category = Repo.insert!(%Category{name: "Test category"})

    KjerSi.Repo.insert!(
      Room.changeset(%Room{}, %{
        name: "Test room",
        category_id: category.id,
        lat: 10.0,
        lng: 2.0,
        radius: 1000
      })
    )

    conn = TestHelper.login_user(conn, user)

    {:ok, conn: conn, user: user, category: category}
  end

  describe "index" do
    test "returns a list of rooms near a point", %{conn: conn} do
      %{"data" => [%{"name" => "Test room", "lat" => 10.0, "lng" => 2.0}]} =
        conn
        |> get(Routes.room_path(conn, :index, lat: "10.001", lng: "2.001"))
        |> json_response(200)

      %{"data" => []} =
        conn
        |> get(Routes.room_path(conn, :index, lat: "10.001", lng: "3"))
        |> json_response(200)
    end

    test "requires lng param to be present", %{conn: conn} do
      %{"errors" => %{}} =
        conn
        |> get(Routes.room_path(conn, :index, lat: "10.001"))
        |> json_response(422)
    end

    test "requires lng param to be a valid float", %{conn: conn} do
      %{"errors" => %{}} =
        conn
        |> get(Routes.room_path(conn, :index, lat: "10.001", lng: "two"))
        |> json_response(422)
    end

    test "requires lat param to be present", %{conn: conn} do
      %{"errors" => %{}} =
        conn
        |> get(Routes.room_path(conn, :index, lng: "2.001"))
        |> json_response(422)
    end

    test "requires lat param to be a valid float", %{conn: conn} do
      %{"errors" => %{}} =
        conn
        |> get(Routes.room_path(conn, :index, lng: "2.001", lat: true))
        |> json_response(422)
    end
  end

  describe "create" do
    test "regular user can create a room", %{conn: conn, user: user, category: category} do
      %{"name" => "New room", "radius" => 5} =
        conn
        |> TestHelper.login_user(user)
        |> post(
          Routes.room_path(conn, :create),
          room: %{name: "New room", lat: 10.1, lng: 2.3, radius: 5, category_id: category.id}
        )
        |> json_response(201)
    end
  end

  describe "categories" do
    test "any user can list room categories", %{conn: conn, user: user} do
      %{"categories" => [%{"name" => "Test category"}]} =
        conn
        |> TestHelper.login_user(user)
        |> get(Routes.room_path(conn, :categories))
        |> json_response(200)
    end
  end
end
