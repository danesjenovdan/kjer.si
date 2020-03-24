ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(KjerSi.Repo, :manual)

defmodule TestHelper do
  use KjerSiWeb.ConnCase

  def generate_category do
    name = "category " <> Integer.to_string(Enum.random(0..1000000))
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
        lng: 120.5,
        name: "some name",
        radius: 42,
        category_id: category.id
      })
    )
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
