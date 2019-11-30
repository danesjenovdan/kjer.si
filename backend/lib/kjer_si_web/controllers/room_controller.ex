defmodule KjerSiWeb.RoomController do
  use KjerSiWeb, :controller

  import Plug.Conn
  import Logger

  alias KjerSi.Rooms.Room
  alias KjerSi.AccountsHelpers

  action_fallback KjerSiWeb.FallbackController

  def create(conn, %{"room" => room_params}) do
    with {:ok, %Room{} = room} <- Rooms.create_room(room_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.room_path(conn, :show, room))
      |> render("show.json", room: room)
    end
  end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
