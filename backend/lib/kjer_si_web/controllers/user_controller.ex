defmodule KjerSiWeb.UserController do
  use KjerSiWeb, :controller

  import Plug.Conn
  import Logger

  alias KjerSi.Accounts
  alias KjerSi.Accounts.User
  alias KjerSi.AccountsHelpers

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    unless AccountsHelpers.is_admin(conn) do
      AccountsHelpers.return_unauthorized(conn)
    else
      users = Accounts.list_users()
      render(conn, "index.json", users: users)
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"uid" => uid}) do
    user = Accounts.get_user_by_uid(uid)
    cond do
      user == nil ->
        AccountsHelpers.return_not_found(conn)
      AccountsHelpers.get_uid(conn) != uid ->
        AccountsHelpers.return_unauthorized(conn)
      true ->
        render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"uid" => uid, "user" => user_params}) do
    user = Accounts.get_user_by_uid(uid)
    cond do
      user == nil ->
        AccountsHelpers.return_not_found(conn)
      AccountsHelpers.get_uid(conn) != uid ->
        AccountsHelpers.return_unauthorized(conn)
      true ->
        with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
          render(conn, "show.json", user: user)
        end
    end
  end

  def delete(conn, %{"uid" => uid}) do
    user = Accounts.get_user_by_uid(uid)
    cond do
      user == nil ->
        AccountsHelpers.return_not_found(conn)
      AccountsHelpers.get_uid(conn) != uid and not AccountsHelpers.is_admin(conn) ->
        AccountsHelpers.return_unauthorized(conn)
      true ->
        with {:ok, %User{}} <- Accounts.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
    end
  end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
