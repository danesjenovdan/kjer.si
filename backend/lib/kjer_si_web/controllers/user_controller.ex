defmodule KjerSiWeb.UserController do
  use KjerSiWeb, :controller

  import Plug.Conn
  import Logger

  alias KjerSi.Accounts
  alias KjerSi.Accounts.User
  alias KjerSi.AccountsHelpers

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    unless Accounts.is_admin(AccountsHelpers.get_uuid(conn)), do: AccountsHelpers.return_unauthorized(conn)

    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    user = Accounts.get_user_by_uuid(uuid)
    unless user, do: AccountsHelpers.return_not_found(conn)
    unless uuid == user.uuid, do: AccountsHelpers.return_unauthorized(conn)

    render(conn, "show.json", user: user)
  end

  def update(conn, %{"uuid" => uuid, "user" => user_params}) do
    user = Accounts.get_user_by_uuid(uuid)
    unless user, do: AccountsHelpers.return_not_found(conn)
    unless uuid == user.uuid, do: AccountsHelpers.return_unauthorized(conn)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    user = Accounts.get_user_by_uuid(uuid)
    unless user, do: AccountsHelpers.return_not_found(conn)
    unless uuid == user.uuid, do: AccountsHelpers.return_unauthorized(conn)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  # This is copy-pasted from a tutorial and will probably require modification.
  # def update_user_channels(user, channel_ids) when is_list(channel_ids) do
  #   channels =
  #     Channel
  #     |> where([channel], channel.id in ^channel_ids)
  #     |> Repo.all()

  #   with {:ok, _struct} <-
  #          user
  #          |> User.changeset_update_channels(channels)
  #          |> Repo.update() do
  #     {:ok, Accounts.get_user(user.id)}
  #   else
  #     error ->
  #       error
  #   end
  # end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
