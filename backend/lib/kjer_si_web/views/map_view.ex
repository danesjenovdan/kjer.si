defmodule KjerSiWeb.MapView do
  use KjerSiWeb, :view
  alias KjerSiWeb.RoomView

  def render("rooms.json", %{rooms: rooms}) do
    %{data: render_many(rooms, RoomView, "room.json")}
  end
end
