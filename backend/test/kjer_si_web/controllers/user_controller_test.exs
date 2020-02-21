defmodule KjerSiWeb.UserControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User

  setup %{conn: conn} do
    {:ok, admin} = Repo.insert(%User{nickname: "admin", uid: "1", is_admin: true})
    {:ok, user} = Repo.insert(%User{nickname: "user", uid: "2", is_admin: false})

    {:ok, conn: conn, admin: admin, user: user}
  end

  defp login_user(conn, user) do
    token = Phoenix.Token.sign(KjerSiWeb.Endpoint, "user auth", user.id)
    put_req_header(conn, "authorization", "Bearer #{token}")
  end

  describe "index" do
    test "regular user can't list other users", %{conn: conn, user: user} do
      %{"error" => "Not allowed to perform action"} =
        conn
        |> login_user(user)
        |> get(Routes.user_path(conn, :index))
        |> json_response(403)
    end

    test "admin user can list other users", %{conn: conn, admin: admin} do
      %{"data" => [%{"nickname" => "admin"}, %{"nickname" => "user"}]} =
        conn
        |> login_user(admin)
        |> get(Routes.user_path(conn, :index))
        |> json_response(200)
    end
  end

  describe "show" do
    test "user can't list info about another user", %{conn: conn, user: user, admin: admin} do
      %{"error" => "Not allowed to perform action"} =
        conn
        |> login_user(user)
        |> get(Routes.user_path(conn, :show, admin.id))
        |> json_response(403)
    end

    test "user can list info about self", %{conn: conn, user: user} do
      %{"data" => %{"nickname" => "user"}} =
        conn
        |> login_user(user)
        |> get(Routes.user_path(conn, :show, user.id))
        |> json_response(200)
    end
  end

  describe "create" do
    test "anyone can create new user", %{conn: conn, admin: admin} do
      conn
      |> post(Routes.user_path(conn, :create), user: %{uid: "42", nickname: "some nickname"})
      |> json_response(201)

      %{"data" => users} =
        conn
        |> login_user(admin)
        |> get(Routes.user_path(conn, :index))
        |> json_response(200)

      assert [
               _,
               _,
               %{
                 "uid" => "42",
                 "nickname" => "some nickname"
               }
             ] = users
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{"errors" => %{"detail" => "Unprocessable Entity"}} =
        conn
        |> post(Routes.user_path(conn, :create), user: %{uid: nil})
        |> json_response(422)
    end
  end

  describe "update" do
    test "users can update themselves", %{conn: conn, user: user} do
      %{"data" => %{"nickname" => "updated nickname"}} =
        conn
        |> login_user(user)
        |> put(Routes.user_path(conn, :update, user), user: %{nickname: "updated nickname"})
        |> json_response(200)
    end

    test "users can't promote themselves to admin", %{conn: conn, user: user} do
      # if someone adds :is_admin to user.ex changeset, this test should catch it
      conn
      |> login_user(user)
      |> put(Routes.user_path(conn, :update, user), user: %{is_admin: true})
      |> get(Routes.user_path(conn, :index))
      |> json_response(403)
    end

    test "user can't deactivate user", %{conn: conn, user: user} do
      conn
      |> login_user(user)
      |> put(Routes.user_path(conn, :update, user), user: %{is_active: false})
      |> json_response(403)
    end

    test "admin can deactivate user", %{conn: conn, user: user, admin: admin} do
      %{"data" => %{"is_active" => false}} =
        conn
        |> login_user(admin)
        |> put(Routes.user_path(conn, :update, user), user: %{is_active: false})
        |> json_response(200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      %{"errors" => %{"detail" => "Unprocessable Entity"}} =
        conn
        |> put(Routes.user_path(conn, :update, user), user: %{uid: nil})
        |> json_response(422)
    end
  end

  describe "delete user" do
    test "admin can delete a user", %{conn: conn, user: user, admin: admin} do
      conn
      |> login_user(admin)
      |> delete(Routes.user_path(conn, :delete, user))
      |> response(204)
    end

    test "user can't delete a user", %{conn: conn, user: user} do
      conn
      |> login_user(user)
      |> delete(Routes.user_path(conn, :delete, user))
      |> response(403)
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
