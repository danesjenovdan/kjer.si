defmodule KjerSiWeb.Admin.AdminRoomController do
  use KjerSiWeb, :controller

  alias KjerSi.Rooms
  alias KjerSi.Rooms.Room

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def delete(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)

    with {:ok, %Room{}} <- Rooms.delete_room(room) do
      send_resp(conn, :no_content, "")
    end
  end
end
