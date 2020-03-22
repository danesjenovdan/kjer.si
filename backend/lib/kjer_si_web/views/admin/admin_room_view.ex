defmodule KjerSiWeb.Admin.AdminRoomView do
  use KjerSiWeb, :view

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, __MODULE__, "room.json", as: :room)}
  end

  def render("room.json", %{room: room}) do
    %{
      id: room.id,
      name: room.name,
      radius: room.radius,
      category_id: room.category_id,
      lat: room.lat,
      lng: room.lng,
      users: render_many(room.users, KjerSiWeb.UserView, "user_nickname.json", as: :user),
      category: render_one(room.category, KjerSiWeb.CategoryView, "category.json", as: :category),
      events: render_many(room.events, KjerSiWeb.EventView, "event.json", as: :event)
    }
  end
end
