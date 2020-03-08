defmodule KjerSiWeb.Admin.AdminUserControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User

  import Ecto.Query

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
        |> get(Routes.admin_user_path(conn, :index))
        |> json_response(403)
    end

    test "admin user can list other users", %{conn: conn, admin: admin} do
      %{"data" => [%{"nickname" => "admin"}, %{"nickname" => "user"}]} =
        conn
        |> login_user(admin)
        |> get(Routes.admin_user_path(conn, :index))
        |> json_response(200)
    end
  end

  describe "update" do
    test "users can't promote themselves to admin", %{conn: conn, user: user} do
      conn
      |> login_user(user)
      |> put(Routes.admin_user_path(conn, :update, user), user: %{is_admin: true})
      |> json_response(403)
    end

    test "not even admin can promote any user to admin", %{conn: conn, user: user, admin: admin} do
      admins_query = User |> where(is_admin: true)
      admins = admins_query |> Repo.all()
      assert length(admins) == 1

      conn
      |> login_user(admin)
      |> put(Routes.admin_user_path(conn, :update, user), user: %{is_admin: true})
      |> json_response(200)

      admins = admins_query |> Repo.all()
      # if someone adds :is_admin to user.ex changeset, this test should catch it
      assert length(admins) == 1
    end

    test "user can't deactivate user", %{conn: conn, user: user} do
      conn
      |> login_user(user)
      |> put(Routes.admin_user_path(conn, :update, user), user: %{is_active: false})
      |> json_response(403)
    end

    test "admin can deactivate user", %{conn: conn, user: user, admin: admin} do
      deactivated_users = User |> where(is_active: false) |> Repo.all()
      assert length(deactivated_users) == 0

      %{"data" => %{"is_active" => false}} =
        conn
        |> login_user(admin)
        |> put(Routes.admin_user_path(conn, :update, user), user: %{is_active: false})
        |> json_response(200)

      deactivated_users_after = User |> where(is_active: false) |> Repo.all()
      assert length(deactivated_users_after) == 1
    end

    test "renders errors when data is invalid", %{conn: conn, admin: admin, user: user} do
      %{"errors" => %{"detail" => "Unprocessable Entity"}} =
        conn
        |> login_user(admin)
        |> put(Routes.admin_user_path(conn, :update, user), user: %{uid: nil})
        |> json_response(422)
    end
  end
end
