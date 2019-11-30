defmodule KjerSiWeb.UserRoomView do
  use KjerSiWeb, :view
  alias KjerSiWeb.UserRoomView

  def render("show.json", %{user_room: user_room}) do
    %{data: render_one(user_room, UserRoomView, "user_room.json")}
  end

  def render("user_room.json", %{user_room: user_room}) do
    %{id: user_room.id,
      room_id: user_room.room_id,
      user_id: user_room.user_id}
  end
end
