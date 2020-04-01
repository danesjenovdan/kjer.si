defmodule KjerSiWeb.UserControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User

  setup %{conn: conn} do
    user = Repo.insert!(%User{nickname: "user", uid: "2", is_admin: false})
    {:ok, conn: conn, user: user}
  end

  describe "create" do
    test "performs login for existing uids", %{conn: conn} do
      users_before = TestHelper.get_user_count()

      %{"data" => %{"nickname" => "user"}} =
        conn
        |> post(Routes.user_path(conn, :create), uid: "2")
        |> json_response(200)

      users_after = TestHelper.get_user_count()

      assert users_after == users_before
    end

    test "returns token upon successful login", %{conn: conn} do
      %{"data" => %{"token" => token}} =
        conn
        |> post(Routes.user_path(conn, :create), uid: "2")
        |> json_response(200)

      assert String.length(token) == 148
    end

    test "performs registration for new uids", %{conn: conn} do
      users_before = TestHelper.get_user_count()

      %{"data" => %{"uid" => "1337"}} =
        conn
        |> post(Routes.user_path(conn, :create), uid: "1337")
        |> json_response(201)

      users_after = TestHelper.get_user_count()

      assert users_after == users_before + 1
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{"errors" => %{"detail" => "Unprocessable Entity"}} =
        conn
        |> post(Routes.user_path(conn, :create), uid: "")
        |> json_response(422)
    end
  end

  describe "self" do
    test "returns themselves to authenticated user", %{conn: conn, user: user} do
      %{"data" => %{"nickname" => "user", "uid" => "2"}} =
        conn
        |> TestHelper.login_user(user)
        |> get(Routes.user_path(conn, :self))
        |> json_response(200)
    end

    test "fails for unauthenticated calls", %{conn: conn} do
      %{"error" => "Authorization header missing or malformed"} =
        conn
        |> get(Routes.user_path(conn, :self))
        |> json_response(401)
    end
  end
end
