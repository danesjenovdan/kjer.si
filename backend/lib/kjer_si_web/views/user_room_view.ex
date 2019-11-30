defmodule KjerSiWeb.UserRoomView do
  use KjerSiWeb, :view
  alias KjerSiWeb.UserRoomView
  alias KjerSiWeb.RoomView

  def render("show.json", %{user_room: user_room}) do
    %{data: render_one(user_room, UserRoomView, "user_room.json")}
  end

  def render("user_room.json", %{user_room: user_room}) do
    %{id: user_room.id,
      room_id: user_room.room_id,
      user_id: user_room.user_id}
  end

  def render("user_rooms_of_user.json", %{user_rooms: user_rooms}) do
    %{rooms: render_many(user_rooms, UserRoomView, "user_room.json")}
  end
end
