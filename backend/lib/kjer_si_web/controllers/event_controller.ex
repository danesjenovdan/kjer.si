defmodule KjerSiWeb.EventController do
  use KjerSiWeb, :controller

  alias KjerSi.Events
  alias KjerSi.Events.Event

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, "index.json", events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event_by_id(id)
    render(conn, "show.json", event: event)
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- Events.create_event(event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, event))
      |> render("show.json", event: event)
    end
  end


  def update(conn, %{"uid" => uid, "event" => event_params}) do
    event = Events.get_event_by_id(uid)
    cond do
      #event == nil ->
      #  AccountsHelpers.return_error(conn, :not_found)
      # AccountsHelpers.get_uid(conn) != user.id ->
      #   AccountsHelpers.return_error(conn, :forbidden)
      true ->
        with {:ok, %Event{} = event} <- Events.update_event(event, event_params) do
          render(conn, "show.json", event: event)
        end
    end
  end

end
