defmodule KjerSiWeb.Router do
  use KjerSiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug KjerSiWeb.Plugs.Auth, "is_admin"
  end

  scope "/api", KjerSiWeb do
    pipe_through :api

    resources "/subscriptions", UserRoomController, only: [:index, :create, :show, :delete]

    # resources "/eventsubscriptions", UserEventController, only: [:index, :create, :delete] # commenting out, because it's not used yet

    # registration
    post "/users", UserController, :create
    get "/generate-username", UserController, :generate_username
    post "/recover-self", UserController, :recover_self
    get "/categories", RoomController, :categories
    post "/rooms", RoomController, :create
    post "/map/rooms", MapController, :get_rooms_in_radius

    # scope "/admin", Admin do # consider moving controller into Admin module
    scope "/admin", Admin do
      pipe_through :admin

      # list & deactivate
      resources "/users", AdminUserController, only: [:index, :update]

      # resources "/events", EventController, param: "uid", only: [:index, :show, :create, :update] # commenting out, because it's not used yet
      resources "/rooms", AdminRoomController, only: [:index, :delete]
    end
  end
end
