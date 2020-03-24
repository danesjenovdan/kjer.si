defmodule KjerSiWeb.RoomView do
  use KjerSiWeb, :view

  def render("rooms.json", %{rooms: rooms}) do
    %{data: render_many(rooms, KjerSiWeb.RoomView, "room.json")}
  end

  def render("new.json", %{room: room}) do
    %{
      id: room.id,
      name: room.name,
      radius: room.radius,
      category_id: room.category_id,
      lat: room.lat,
      lng: room.lng,
      users: []
    }
  end

  def render("room.json", %{room: room}) do
    %{
      id: room.id,
      name: room.name,
      radius: room.radius,
      category_id: room.category_id,
      lat: room.lat,
      lng: room.lng,
      users: render_many(room.users, KjerSiWeb.UserView, "user_nickname.json")
    }
  end
end
