defmodule KjerSiWeb.RoomController do
  use KjerSiWeb, :controller
  use Params

  alias KjerSi.Rooms
  alias KjerSi.Rooms.Room

  action_fallback KjerSiWeb.FallbackController

  defparams room_index(%{
              lng!: :float,
              lat!: :float
            })

  def index(conn, params) do
    changeset = room_index(params)

    if changeset.valid? do
      point = %Geo.Point{coordinates: {params["lng"], params["lat"]}, srid: 4326}
      rooms = Rooms.get_rooms_around_point(point)
      render(conn, "rooms.json", rooms: rooms)
    else
      {:error, changeset}
    end
  end

  def create(conn, %{"room" => room_params}) do
    with {:ok, %Room{} = room} <- Rooms.create_room(room_params) do
      conn
      |> put_status(:created)
      |> render("new.json", room: room)
    end
  end

  def categories(conn, _params) do
    conn
    |> put_view(KjerSiWeb.CategoryView)
    |> render("categories.json", categories: Rooms.list_categories())
  end
end
