defmodule KjerSiWeb.UserControllerTest do
  use KjerSiWeb.ConnCase
  require Logger
  alias KjerSi.Accounts
  alias KjerSi.Accounts.User

  @create_attrs %{
    uid: "42",
    nickname: "some nickname"
  }
  @update_attrs %{
    uid: "43",
    nickname: "some updated nickname"
  }
  @invalid_attrs %{uid: nil, nickname: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "is_active" => true,
               "uid" => "42",
               "nickname" => "some nickname"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "uid" => "43",
               "nickname" => "some updated nickname"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  describe "recover self" do
    setup [:create_user]

    test "generates token", %{conn: conn, user: user} do
      conn = post(conn, Routes.user_path(conn, :recover_self), %{ uid: user.uid })

      assert json_response(conn, 200)
      assert String.length(json_response(conn, 200)["token"]) == 148

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :recover_self), %{ uid: user.uid })
      end
    end
  end

  defp create_user(_) do
    Logger.debug("yeah this is called")
    user = fixture(:user)
    {:ok, user: user}
  end
end
