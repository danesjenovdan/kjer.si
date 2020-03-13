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

  describe "recover self" do
    test "generates token", %{conn: conn, user: user} do
      %{"token" => token} =
        conn
        |> post(Routes.user_path(conn, :recover_self), %{uid: user.uid})
        |> json_response(200)

      assert String.length(token) == 148

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :recover_self), %{uid: user.uid})
      end
    end
  end
end
