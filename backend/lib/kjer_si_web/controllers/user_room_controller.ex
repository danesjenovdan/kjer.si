defmodule KjerSiWeb.UserRoomController do
  use KjerSiWeb, :controller

  import Plug.Conn
  import Logger

  alias KjerSi.Accounts
  alias KjerSi.Accounts.UserRoom
  alias KjerSi.AccountsHelpers

  action_fallback KjerSiWeb.FallbackController

  def create(conn, %{"subscription" => subscription_params}) do
    with {:ok, %UserRoom{} = user_room} <- Accounts.create_user_room(subscription_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user_room))
      |> send_resp(:no_content, "{}")
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    # user = Accounts.get_user_by_uuid(uuid)
    # unless user, do: AccountsHelpers.return_not_found(conn)
    # unless Accounts.is_admin(AccountsHelpers.get_uuid(conn)) do
    #   unless uuid == AccountsHelpers.get_uuid(conn), do: AccountsHelpers.return_unauthorized(conn)
    # end

    # with {:ok, %User{}} <- Accounts.delete_user(user) do
    send_resp(conn, :no_content, "")
    # end
  end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
