defmodule KjerSiWeb.SubscriptionController do
  use KjerSiWeb, :controller
  use Params

  alias KjerSi.Accounts
  alias KjerSi.Accounts.Subscription
  alias KjerSi.Rooms

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    subscriptions = Accounts.list_subscriptions(user.id)
    render(conn, "index.json", subscriptions: subscriptions)
  end

  def create(conn, %{"room_id" => room_id}) do
    subscription_params = %{
      "user_id" => conn.assigns[:current_user].id,
      "room_id" => room_id
    }

    with {:ok, %Subscription{} = subscription} <-
           Accounts.create_subscription(subscription_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.subscription_path(conn, :show, subscription.id))
      |> render("show.json", subscription: subscription)
    end
  end

  def show(conn, %{"id" => id}) do
    subscription = Accounts.get_subscription!(id)
    render(conn, "show.json", subscription: subscription)
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Subscription{} = subscription} <- Accounts.delete_subscription(id) do
      room_id = subscription.room_id

      # check if room is empty and delete room
      with {:ok, room} = Rooms.get_room(room_id, [:users]) do
        if length(room.users) == 0 do
          Rooms.delete_room(room)
        end
      end

      send_resp(conn, :no_content, "")
    end
  end

  def delete_by_room_id(conn, %{"room_id" => room_id}) do
    user_id = conn.assigns[:current_user].id

    with {:ok, %Subscription{} = subscription} <- Accounts.get_subscription(user_id, room_id) do
      conn
      |> put_status(307)
      |> redirect(to: Routes.subscription_path(conn, :delete, subscription.id))
    end
  end
end
