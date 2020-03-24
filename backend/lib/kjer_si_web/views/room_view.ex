defmodule KjerSiWeb.RoomView do
  use KjerSiWeb, :view

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, KjerSiWeb.RoomView, "room.json")}
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, KjerSiWeb.RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{
      id: room.id,
      name: room.name,
      radius: room.radius,
      categoryId: room.category_id,
      lat: room.lat,
      lng: room.lng,
      description: room.description,
      users: render_many(room.users, KjerSiWeb.UserView, "user_nickname.json")
    }
  end
end
