ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(KjerSi.Repo, :manual)

defmodule TestHelper do
  use KjerSiWeb.ConnCase

  def generate_category do
    name = "category " <> Integer.to_string(Enum.random(0..1_000_000))

    KjerSi.Repo.insert!(%KjerSi.Rooms.Category{
      name: name
    })
  end

  def generate_user do
    KjerSi.Repo.insert!(%KjerSi.Accounts.User{
      nickname: "TestNickname",
      uid: "1337"
    })
  end

  def generate_room do
    category = generate_category()

    KjerSi.Repo.insert!(
      KjerSi.Rooms.Room.changeset(%KjerSi.Rooms.Room{}, %{
        lat: 120.5,
        lng: 121.4,
        name: "Test room",
        radius: 42.0,
        category_id: category.id,
        description: "Test description"
      })
    )
  end

  def generate_event(user_id, room_id) do
    {:ok, random_date, 0} = DateTime.from_iso8601("2019-11-30 12:12:12Z")

    KjerSi.Repo.insert!(%KjerSi.Events.Event{
      name: "Test event",
      datetime: random_date,
      location: "Test location",
      description: "Just a description of the event",
      max_attending: 2,
      user_id: user_id,
      room_id: room_id
    })
  end

  def login_user(conn, user) do
    token = Phoenix.Token.sign(KjerSiWeb.Endpoint, "user auth", user.id)
    put_req_header(conn, "authorization", "Bearer #{token}")
  end

  def get_user_count do
    users = KjerSi.Accounts.User |> KjerSi.Repo.all()
    length(users)
  end
end
