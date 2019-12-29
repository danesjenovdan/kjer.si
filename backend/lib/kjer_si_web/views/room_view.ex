defmodule KjerSiWeb.RoomView do
  use KjerSiWeb, :view
  alias KjerSiWeb.RoomView

  def render("show.json", %{room: room}) do
    %{data: render_one(room, RoomView, "room.json")}
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

  def render("categories.json", %{categories: categories}) do
    %{categories: render_many(categories, RoomView, "category.json")}
  end

  # this is a bit of a hack but it exposes how phoenix works
  # when you call render_many it assigns the key in the struct
  # based on the ?module name? or something else beyond our control
  def render("category.json", %{room: category}) do
    %{
      id: category.id,
      name: category.name
    }
  end
end
