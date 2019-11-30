defmodule KjerSiWeb.RoomView do
  use KjerSiWeb, :view
  alias KjerSiWeb.RoomView

  def render("show.json", %{room: room}) do
    %{data: render_one(room, RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{
      name: room.name,
      radius: room.radius,
      # category: render_one(room.category, KjerSiWeb.CategoryView, "category.json")
      category_id: room.category_id
    }
  end
end
