defmodule KjerSiWeb.SubscriptionView do
  use KjerSiWeb, :view
  alias KjerSiWeb.SubscriptionView

  def render("show.json", %{subscription: subscription}) do
    %{data: render_one(subscription, SubscriptionView, "subscription.json")}
  end

  def render("subscription.json", %{subscription: subscription}) do
    %{id: subscription.id,
      room_id: subscription.room_id,
      user_id: subscription.user_id}
  end

  def render("subscriptions_of_user.json", %{subscriptions: subscriptions}) do
    %{rooms: render_many(subscriptions, SubscriptionView, "subscription.json")}
  end
end
