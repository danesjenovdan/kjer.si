defmodule KjerSiWeb.UserControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User

  setup %{conn: conn} do
    user = Repo.insert!(%User{nickname: "user", uid: "2", is_admin: false})
    {:ok, conn: conn, user: user}
  end

  describe "create" do
    test "anyone can create new user", %{conn: conn} do
      conn
      |> post(Routes.user_path(conn, :create), user: %{uid: "42", nickname: "some nickname"})
      |> json_response(201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{"errors" => %{"detail" => "Unprocessable Entity"}} =
        conn
        |> post(Routes.user_path(conn, :create), user: %{uid: nil})
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
