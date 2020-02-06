defmodule KjerSiWeb.MapController do
  use KjerSiWeb, :controller

  import Plug.Conn

  alias KjerSi.Rooms

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    send_resp(conn, :no_content, "")
  end

  def get_rooms_in_radius(conn, %{"lat" => lat, "lng" => lng}) do
    point = %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    rooms = Rooms.get_rooms_around_point(point)
    render(conn, "rooms.json", rooms: rooms)
  end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
