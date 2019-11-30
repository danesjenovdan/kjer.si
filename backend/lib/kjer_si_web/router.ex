defmodule KjerSiWeb.Router do
  use KjerSiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KjerSiWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    resources "/subscriptions", UserRoomController, only: [:create, :show, :delete]
    resources "/events", EventController, param: "id", only: [:index, :show, :create]
    resources "/eventsubscriptions", UserEventController, param: "event_id", only: [:create, :delete]
    resources "/rooms", RoomController, only: [:create, :delete, :show]
  end
end
