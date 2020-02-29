defmodule KjerSiWeb.RoomController do
  use KjerSiWeb, :controller

  alias KjerSi.AccountsHelpers
  alias KjerSi.Rooms
  alias KjerSi.Rooms.Room

  action_fallback KjerSiWeb.FallbackController

  plug :is_admin when action in [:delete]

  def create(conn, %{"room" => room_params}) do
    with {:ok, %Room{} = room} <- Rooms.create_room(room_params) do
      conn
      |> put_status(:created)
      |> render("new.json", room: room)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    with {:ok, %Room{}} <- Rooms.delete_room(room) do
      send_resp(conn, :no_content, "")
    end
  end

  def show(conn, %{"id" => id}) do
    render conn, "room.json", room: Rooms.get_room!(id, [:users])
  end

  def categories(conn, _params) do
    conn
    |> put_view(KjerSiWeb.CategoryView)
    |> render("categories.json", categories: Rooms.list_categories)
  end

  defp is_admin(conn, _opts) do
    if AccountsHelpers.is_admin(conn) do
      conn
    else
      AccountsHelpers.return_error(conn, :forbidden)
    end
  end
end
