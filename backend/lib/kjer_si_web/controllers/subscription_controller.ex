defmodule KjerSiWeb.SubscriptionController do
  use KjerSiWeb, :controller

  alias KjerSi.Accounts
  alias KjerSi.Accounts.User
  alias KjerSi.Accounts.Subscription
  alias KjerSi.AccountsHelpers
  alias KjerSi.Rooms

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    with {:ok, %User{} = user} <- AccountsHelpers.get_auth_user(conn) do
      subscriptions = Accounts.list_subscriptions_by_user(user)
      render(conn, "subscriptions_of_user.json", subscriptions: subscriptions)
    end
  end

  def create(conn, %{"subscription" => subscription_params}) do
    with {:ok, user} = AccountsHelpers.get_auth_user(conn) do
      if subscription_params["user_id"] == user.id do
        with {:ok, %Subscription{} = subscription} <- Accounts.create_subscription(subscription_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.subscription_path(conn, :show, subscription.id))
          |> render("show.json", subscription: subscription)
        end
      else
        AccountsHelpers.return_error(conn, :forbidden)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    subscription = Accounts.get_subscription!(id)
    render(conn, "show.json", subscription: subscription)
  end

  def delete(conn, %{"id" => id}) do
    with subscription = Accounts.get_subscription!(id) do
      with {:ok, user} = AccountsHelpers.get_auth_user(conn) do
        if subscription.user_id == user.id do
          # save room ID for later
          room_id = subscription.room_id
          with {:ok, %Subscription{}} <- Accounts.delete_subscription(subscription) do
            # check if room is empty and delete room
            with room = Rooms.get_room!(room_id, [:users]) do
              if length(room.users) == 0 do
                Rooms.delete_room(room)
              end
            end
            send_resp(conn, :no_content, "")
          end
        else
          AccountsHelpers.return_error(conn, :forbidden)
        end
      end
    end
  end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
