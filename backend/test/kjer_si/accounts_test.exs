defmodule KjerSi.AccountsTest do
  use KjerSi.DataCase

  alias KjerSi.Accounts

  describe "users" do
    alias KjerSi.Accounts.User

    @valid_attrs %{uid: "42", nickname: "some nickname"}
    @update_attrs %{uid: "43", nickname: "some updated nickname"}
    @invalid_attrs %{uid: nil, nickname: nil}

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
      assert user.uid == "42"
      assert user.nickname == "some nickname"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.uid == "43"
      assert user.nickname == "some updated nickname"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "subscriptions" do
    alias KjerSi.Accounts.Subscription

    def subscription_fixture() do
      test_user = TestHelper.generate_user()
      test_room = TestHelper.generate_room()

      {:ok, subscription} =
        Accounts.create_subscription(%{
          user_id: test_user.id,
          room_id: test_room.id
        })

      subscription
    end

    test "list_subscriptions/0 returns all subscriptions for given user_id" do
      subscription = subscription_fixture()
      user_id = subscription.user_id
      assert Accounts.list_subscriptions(user_id) == [subscription]
    end

    test "get_subscription/1 returns {:ok, subscription} if subscription with given id exists" do
      subscription = subscription_fixture()
      assert Accounts.get_subscription(subscription.id) == {:ok, subscription}
    end

    test "get_subscription/1 returns {:error, :not_found} if subscription with given id does not exist" do
      fake_id = "ba294533-82b6-4cbb-abc1-167cd7bf4bb1"
      assert Accounts.get_subscription(fake_id) == {:error, :not_found}
    end

    test "get_subscription/2 returns {:ok, subscription} if subscription exists for given user_id and room_id" do
      user = TestHelper.generate_user()
      room = TestHelper.generate_room()

      {:ok, subscription} =
        Accounts.create_subscription(%{
          user_id: user.id,
          room_id: room.id
        })

      assert Accounts.get_subscription(user.id, room.id) == {:ok, subscription}
    end

    test "get_subscription/2 returns {:error, :not_found} if subscription doesn't exist for given user_id and room_id" do
      fake_id = "ba294533-82b6-4cbb-abc1-167cd7bf4bb1"
      assert Accounts.get_subscription(fake_id, fake_id) == {:error, :not_found}
    end

    test "create_subscription/1 with valid data creates a subscription" do
      test_user = TestHelper.generate_user()
      test_room = TestHelper.generate_room()

      assert {:ok, %Subscription{} = subscription} =
               Accounts.create_subscription(%{
                 user_id: test_user.id,
                 room_id: test_room.id
               })
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_subscription(%{
                 user_id: "clearly invalid",
                 room_id: -6
               })
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Accounts.delete_subscription(subscription.id)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_subscription!(subscription.id) end
    end
  end
end
