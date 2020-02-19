defmodule KjerSiWeb.UserEventController do
  use KjerSiWeb, :controller

  import Plug.Conn

  alias KjerSi.Events
  alias KjerSi.Accounts.User
  alias KjerSi.Events.UserEvent
  alias KjerSi.AccountsHelpers

  def create(conn, %{"subscription" => subscription_params}) do
    with {:ok, %UserEvent{} = user_event} <- Events.create_user_event(subscription_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user_event.id))
      |> render("show.json", user_event: user_event)
    end
  end

  def index(conn, _params) do
    with {:ok, %User{} = user} <- AccountsHelpers.get_auth_user(conn) do
      user_event = Events.get_events_of_user(user)
      render(conn, "user_event_of_user.json", user_event: user_event)
    end
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
