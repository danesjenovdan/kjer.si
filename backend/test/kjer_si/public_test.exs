defmodule KjerSi.PublicTest do
  use KjerSi.DataCase

  alias KjerSi.Public

  describe "users" do
    alias KjerSi.Public.User

    @valid_attrs %{uuid: 42, nickname: "some nickname"}
    @update_attrs %{uuid: 43, nickname: "some updated nickname"}
    @invalid_attrs %{uuid: nil, nickname: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Public.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Public.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Public.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Public.create_user(@valid_attrs)
      assert user.uuid == 42
      assert user.nickname == "some nickname"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Public.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Public.update_user(user, @update_attrs)
      assert user.uuid == 43
      assert user.nickname == "some updated nickname"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Public.update_user(user, @invalid_attrs)
      assert user == Public.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Public.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Public.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Public.change_user(user)
    end
  end
end
