defmodule KjerSi.ChannelsTest do
  use KjerSi.DataCase

  alias KjerSi.Channels

  describe "categories" do
    alias KjerSi.Channels.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channels.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Channels.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Channels.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Channels.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channels.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Channels.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Channels.update_category(category, @invalid_attrs)
      assert category == Channels.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Channels.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Channels.change_category(category)
    end
  end

  describe "channels" do
    alias KjerSi.Channels.Channel

    @valid_attrs %{lat: 120.5, lng: 120.5, name: "some name", radius: 42, uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{lat: 456.7, lng: 456.7, name: "some updated name", radius: 43, uuid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{lat: nil, lng: nil, name: nil, radius: nil, uuid: nil}

    def channel_fixture(attrs \\ %{}) do
      {:ok, channel} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channels.create_channel()

      channel
    end

    test "list_channels/0 returns all channels" do
      channel = %{ channel_fixture() | lat: nil, lng: nil }
      assert Channels.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id" do
      channel = %{ channel_fixture() | lat: nil, lng: nil }
      assert Channels.get_channel!(channel.id) == channel
    end

    test "create_channel/1 with valid data creates a channel" do
      assert {:ok, %Channel{} = channel} = Channels.create_channel(@valid_attrs)
      assert channel.coordinates == %Geo.Point{coordinates: {120.5, 120.5}, srid: 4326}
      assert channel.name == "some name"
      assert channel.radius == 42
      assert channel.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channels.create_channel(@invalid_attrs)
    end

    test "update_channel/2 with valid data updates the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{} = channel} = Channels.update_channel(channel, @update_attrs)
      assert channel.coordinates == %Geo.Point{coordinates: {456.7, 456.7}, srid: 4326}
      assert channel.name == "some updated name"
      assert channel.radius == 43
      assert channel.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_channel/2 with invalid data returns error changeset" do
      channel = %{ channel_fixture() | lat: nil, lng: nil }
      assert {:error, %Ecto.Changeset{}} = Channels.update_channel(channel, @invalid_attrs)
      assert channel == Channels.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_channel!(channel.id) end
    end

    test "change_channel/1 returns a channel changeset" do
      channel = channel_fixture()
      assert %Ecto.Changeset{} = Channels.change_channel(channel)
    end
  end
end
