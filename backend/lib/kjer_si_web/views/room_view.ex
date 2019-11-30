defmodule KjerSiWeb.RoomView do
  use KjerSiWeb, :view

  def render("show.json", %{room: room}) do
    %{data: render_one(room, RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{uuid: room.uuid,
      name: room.name,
      lat: room.lat,
      lng: room.lng,
      radius: room.radius}
      # belongs_to :category, KjerSi.Rooms.Category
  end
end
