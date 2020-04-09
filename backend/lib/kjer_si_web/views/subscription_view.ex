defmodule KjerSiWeb.SubscriptionView do
  use KjerSiWeb, :view
  alias KjerSiWeb.SubscriptionView

  def render("index.json", %{subscriptions: subscriptions}) do
    %{data: render_many(subscriptions, SubscriptionView, "subscription.json")}
  end

  def render("show.json", %{subscription: subscription}) do
    %{data: render_one(subscription, SubscriptionView, "subscription.json")}
  end

  def render("subscription.json", %{subscription: subscription}) do
    %{id: subscription.id, roomId: subscription.room_id, userId: subscription.user_id}
  end
end
