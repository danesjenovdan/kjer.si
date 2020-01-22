defmodule KjerSiWeb.Router do
  use KjerSiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    use Plug.Debugger # TODO Disable before production
  end

  scope "/api", KjerSiWeb do
    pipe_through :api
    resources "/users", UserController, param: "uid", except: [:new, :edit]
    resources "/subscriptions", UserRoomController, only: [:index, :create, :show, :delete]
    resources "/events", EventController, param: "uid", only: [:index, :show, :create, :update]
    resources "/eventsubscriptions", UserEventController, only: [:create, :delete]
    resources "/rooms", RoomController, only: [:create, :delete, :show]

    post "/map/rooms", MapController, :get_rooms_in_radius
    get "/generate-username", UserController, :generate_username
    get "/categories", RoomController, :categories
    get "/recover-self", UserController, :recover_self
  end
end
