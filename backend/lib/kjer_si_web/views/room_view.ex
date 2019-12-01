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
      users: render_many(room.users, KjerSiWeb.UserView, "user_id.json")
    }
  end
end
