defmodule KjerSiWeb.Router do
  use KjerSiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KjerSiWeb do
    pipe_through :api
    resources "/users", UserController, param: "uid", except: [:new, :edit]
    resources "/subscriptions", UserRoomController, param: "room_id", only: [:create, :delete]
    resources "/events", EventController, param: "id", only: [:index, :show, :create]
  end
end
