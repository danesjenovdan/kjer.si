defmodule KjerSiWeb.RoomController do
  use KjerSiWeb, :controller

  import Plug.Conn

  alias KjerSi.AccountsHelpers
  alias KjerSi.Rooms
  alias KjerSi.Rooms.Room

  action_fallback KjerSiWeb.FallbackController

  def create(conn, %{"room" => room_params}) do
    with {:ok, %Room{} = room} <- Rooms.create_room(room_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.room_path(conn, :show, room))
      |> render("show.json", room: room)
      # |> render("show.json", room: Rooms.get_room!(room.id))
    end
  end

  def delete(conn, %{"id" => id}) do
    if AccountsHelpers.is_admin(conn) do
      room = Rooms.get_room!(id)
      with {:ok, %Room{}} <- Rooms.delete_room(room) do
        send_resp(conn, :no_content, "")
      end
    end
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.json", room: Rooms.get_room!(id, [:users])
  end

  def categories(conn, _params) do
    render conn, "categories.json", categories: Rooms.list_categories
  end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
