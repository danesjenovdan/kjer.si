ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(KjerSi.Repo, :manual)

defmodule TestHelper do
  def generate_category do
    {:ok, category} = KjerSi.Rooms.create_category(%{
      name: "Test category",
    })
    category
  end

  def generate_user do
    {:ok, user} = KjerSi.Accounts.create_user(%{
      nickname: "TestNickname",
      uid: "1337",
    })
    user
  end

  def generate_room do
    test_category = generate_category()
    {:ok, room} = KjerSi.Rooms.create_room(%{
      lat: 120.5,
      lng: 120.5,
      name: "some name",
      radius: 42,
      category_id: test_category.id,
    })
    room
  end
end
