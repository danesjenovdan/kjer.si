defmodule KjerSi.AccountsTest do
  use KjerSi.DataCase

  alias KjerSi.Accounts

  describe "users" do
    alias KjerSi.Accounts.User

    @valid_attrs %{uuid: 42, nickname: "some nickname"}
    @update_attrs %{uuid: 43, nickname: "some updated nickname"}
    @invalid_attrs %{uuid: nil, nickname: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.uuid == 42
      assert user.nickname == "some nickname"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.uuid == 43
      assert user.nickname == "some updated nickname"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "user_channels" do
    alias KjerSi.Accounts.UserChannel

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_channel_fixture(attrs \\ %{}) do
      {:ok, user_channel} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_channel()

      user_channel
    end

    test "list_user_channels/0 returns all user_channels" do
      user_channel = user_channel_fixture()
      assert Accounts.list_user_channels() == [user_channel]
    end

    test "create_user_channel/1 with valid data creates a user_channel" do
      assert {:ok, %UserChannel{} = user_channel} = Accounts.create_user_channel(@valid_attrs)
    end

    test "create_user_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_channel(@invalid_attrs)
    end

    test "delete_user_channel/1 deletes the user_channel" do
      user_channel = user_channel_fixture()
      assert {:ok, %UserChannel{}} = Accounts.delete_user_channel(user_channel)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_channel!(user_channel.id) end
    end
  end
end