defmodule KjerSiWeb.UserRoomController do
  use KjerSiWeb, :controller

  import Plug.Conn

  alias KjerSi.Accounts
  alias KjerSi.Accounts.User
  alias KjerSi.Accounts.UserRoom
  alias KjerSi.AccountsHelpers

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    with {:ok, %User{} = user} <- AccountsHelpers.get_auth_user(conn, [:rooms]) do
      render(conn, "user_rooms_of_user.json", rooms: user.rooms)
    end
  end

  def create(conn, %{"subscription" => subscription_params}) do
    with {:ok, %UserRoom{} = user_room} <- Accounts.create_user_room(subscription_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_room_path(conn, :show, user_room.id))
      |> render("show.json", user_room: user_room)
    end
  end

  def show(conn, %{"id" => id}) do
    user_room = Accounts.get_user_room!(id)
    render(conn, "show.json", user_room: user_room)
  end

  def delete(conn, %{"id" => id}) do
    user_room = Accounts.get_user_room!(id)

    with {:ok, %UserRoom{}} <- Accounts.delete_user_room(user_room) do
      send_resp(conn, :no_content, "")
    end
  end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
