defmodule KjerSi.RoomsTest do
  use KjerSi.DataCase

  alias KjerSi.Rooms

  describe "categories" do
    alias KjerSi.Rooms.Category

    @valid_attrs %{name: "some name", description: "some description"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Rooms.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Rooms.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Rooms.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Rooms.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_category(category, @invalid_attrs)
      assert category == Rooms.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Rooms.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Rooms.change_category(category)
    end
  end

  describe "rooms" do
    alias KjerSi.Rooms.Room

    @valid_attrs %{
      lat: 120.5,
      lng: 120.5,
      name: "some name",
      description: "some description",
      radius: 42.0
    }
    @update_attrs %{lat: 456.7, lng: 456.7, name: "some updated name", radius: 43}
    @invalid_attrs %{lat: nil, lng: nil, name: nil, radius: nil}

    test "list_rooms/0 returns all rooms" do
      TestHelper.generate_room()
      [%{users: [], events: [], category: %KjerSi.Rooms.Category{}}] = Rooms.list_rooms()
    end

    test "get_room!/1 returns the room with given id" do
      room = TestHelper.generate_room()
      assert Rooms.get_room!(room.id) == room
    end

    test "get_room/1 returns {:ok, room} if room with given id exists" do
      room = TestHelper.generate_room()
      assert Rooms.get_room(room.id) == {:ok, room}
    end

    test "get_room/1 supports preload as second argument" do
      room = %{TestHelper.generate_room() | users: []}
      assert Rooms.get_room(room.id, [:users]) == {:ok, room}
    end

    test "get_room/1 returns {:error, :not_found} if room with given id does not exist" do
      fake_id = "ba294533-82b6-4cbb-abc1-167cd7bf4bb1"
      assert Rooms.get_room(fake_id) == {:error, :not_found}
    end

    test "create_room/1 with valid data creates a room" do
      category_id = TestHelper.generate_category().id
      attrs = Map.merge(@valid_attrs, %{category_id: category_id})

      assert {:ok, %Room{} = room} = Rooms.create_room(attrs)
      assert room.coordinates == %Geo.Point{coordinates: {120.5, 120.5}, srid: 4326}
      assert room.name == "some name"
      assert room.radius == 42.0
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = TestHelper.generate_room()
      assert {:ok, %Room{} = room} = Rooms.update_room(room, @update_attrs)
      assert room.coordinates == %Geo.Point{coordinates: {456.7, 456.7}, srid: 4326}
      assert room.name == "some updated name"
      assert room.radius == 43.0
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = TestHelper.generate_room()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = TestHelper.generate_room()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "delete_room/1 cascade-deletes related events" do
      room = TestHelper.generate_room()
      user = TestHelper.generate_user()
      event = TestHelper.generate_event(user.id, room.id)

      assert KjerSi.Events.list_events() == [event]
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert KjerSi.Events.list_events() == []
    end

    test "change_room/1 returns a room changeset" do
      room = TestHelper.generate_room()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end
end
