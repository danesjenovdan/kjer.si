defmodule KjerSiWeb.UserRoomController do
  use KjerSiWeb, :controller

  import Plug.Conn

  alias KjerSi.Accounts
  alias KjerSi.Accounts.User
  alias KjerSi.Accounts.UserRoom
  alias KjerSi.AccountsHelpers
  alias KjerSi.Rooms

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    with {:ok, %User{} = user} <- AccountsHelpers.get_auth_user(conn) do
      user_rooms = Accounts.list_user_rooms_by_user(user)
      render(conn, "user_rooms_of_user.json", user_rooms: user_rooms)
    end
  end

  def create(conn, %{"subscription" => subscription_params}) do
    with {:ok, user} = AccountsHelpers.get_auth_user(conn) do
      if subscription_params["user_id"] == user.id do
        with {:ok, %UserRoom{} = user_room} <- Accounts.create_user_room(subscription_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_room_path(conn, :show, user_room.id))
          |> render("show.json", user_room: user_room)
        end
      else
        AccountsHelpers.return_error(conn, :forbidden)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user_room = Accounts.get_user_room!(id)
    render(conn, "show.json", user_room: user_room)
  end

  def delete(conn, %{"id" => id}) do
    with user_room = Accounts.get_user_room!(id) do
      with {:ok, user} = AccountsHelpers.get_auth_user(conn) do
        if user_room.user_id == user.id do
          # save room ID for later
          room_id = user_room.room_id
          with {:ok, %UserRoom{}} <- Accounts.delete_user_room(user_room) do
            # check if room is empty and delete room
            with room = Rooms.get_room!(room_id, [:users]) do
              if length(room.users) == 0 do
                Rooms.delete_room(room)
              end
            end
            send_resp(conn, :no_content, "")
          end
        else
          AccountsHelpers.return_error(conn, :forbidden)
        end
      end
    end
  end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
