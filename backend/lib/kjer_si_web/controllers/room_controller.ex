defmodule KjerSiWeb.RoomController do
  use KjerSiWeb, :controller
  use Params

  alias KjerSi.Rooms
  alias KjerSi.Rooms.Room
  alias KjerSi.Accounts
  alias KjerSi.Accounts.Subscription

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
      render(conn, "index.json", rooms: rooms)
    else
      {:error, changeset}
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, room} = Rooms.get_room(id, [:users]) do
      render(conn, "show.json", room: room)
    end
  end

  def create(conn, room_params) do
    with {:ok, %Room{} = room} <- Rooms.create_room(room_params) do
      subscription_params = %{
        "user_id" => conn.assigns[:current_user].id,
        "room_id" => room.id
      }

      with {:ok, %Subscription{}} <- Accounts.create_subscription(subscription_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.room_path(conn, :show, room))
        |> render("show.json", room: room)
      end
    end
  end
end
