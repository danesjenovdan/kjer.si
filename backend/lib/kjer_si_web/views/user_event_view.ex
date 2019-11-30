defmodule KjerSiWeb.UserEventView do
  use KjerSiWeb, :view
  alias KjerSiWeb.UserEventView

  def render("show.json", %{user_event: user_event}) do
    %{data: render_one(user_event, UserEventView, "user_event.json")}
  end

  def render("user_event.json", %{user_event: user_event}) do
    %{id: user_event.id,
      event_id: user_event.event_id,
      user_id: user_event.user_id}
  end
end
