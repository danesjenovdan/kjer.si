defmodule KjerSiWeb.UserEventController do
  use KjerSiWeb, :controller

  import Plug.Conn
  import Logger

  alias KjerSi.Events
  alias KjerSi.Events.UserEvent
  alias KjerSi.AccountsHelpers

  action_fallback KjerSiWeb.FallbackController

  def create(conn, %{"subscription" => subscription_params}) do
    with {:ok, %UserEvent{} = user_event} <- Events.create_user_event(subscription_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_event_path(conn, :show, user_event.id))
      |> render("show.json", user_event: user_event)
    end
  end

  def show(conn, %{"id" => id}) do
    user_event = Events.get_user_event!(id)
    render(conn, "show.json", user_event: user_event)
  end

  def delete(conn, %{"id" => id}) do
    user_event = Events.get_user_event!(id)
    with {:ok, %UserEvent{}} <- Events.delete_user_event(user_event) do
    send_resp(conn, :no_content, "")
    end
  end
end

# TODO
# make sure only admins can do admin stuff
# make sure users can only access info about / delete themselves
