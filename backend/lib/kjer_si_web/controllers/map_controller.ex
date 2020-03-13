defmodule KjerSiWeb.MapController do
  use KjerSiWeb, :controller

  alias KjerSi.Rooms

  action_fallback KjerSiWeb.FallbackController

  def get_rooms_in_radius(conn, %{"lat" => lat, "lng" => lng}) do
    point = %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    rooms = Rooms.get_rooms_around_point(point)
    render(conn, "rooms.json", rooms: rooms)
  end
end
