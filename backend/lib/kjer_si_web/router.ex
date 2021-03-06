defmodule KjerSiWeb.Router do
  use KjerSiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug KjerSiWeb.Plugs.Auth, "is_logged_in"
  end

  pipeline :admin do
    plug KjerSiWeb.Plugs.Auth, "is_admin"
  end

  scope "/api", KjerSiWeb do
    pipe_through :api

    # resources "/eventsubscriptions", UserEventController, only: [:index, :create, :delete] # commenting out, because it's not used yet

    scope "/" do
      pipe_through :auth

      get "/users/self", UserController, :self
      resources "/subscriptions", SubscriptionController, only: [:index, :create, :show, :delete]
      get "/categories", CategoryController, :index

      resources "/rooms", RoomController, only: [:index, :create, :show] do
        get "/messages", MessageController, :index
        delete "/subscriptions", SubscriptionController, :delete_by_room_id
      end
    end

    get "/health", HealthController, :index

    post "/users", UserController, :create

    scope "/admin", Admin do
      pipe_through :admin

      # list & deactivate
      resources "/users", AdminUserController, only: [:index, :update]

      # resources "/events", EventController, param: "uid", only: [:index, :show, :create, :update] # commenting out, because it's not used yet
      resources "/rooms", AdminRoomController, only: [:index, :delete]
    end
  end
end
