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

    resources "/subscriptions", SubscriptionController, only: [:index, :create, :show, :delete]

    # resources "/eventsubscriptions", UserEventController, only: [:index, :create, :delete] # commenting out, because it's not used yet

    scope "/" do
      pipe_through :auth

      get "/users/self", UserController, :self

      resources "/rooms", RoomController, only: [:index, :create] do
        get "/messages", MessageController, :index
      end
    end

    post "/users", UserController, :create
    get "/categories", RoomController, :categories

    scope "/admin", Admin do
      pipe_through :admin

      # list & deactivate
      resources "/users", AdminUserController, only: [:index, :update]

      # resources "/events", EventController, param: "uid", only: [:index, :show, :create, :update] # commenting out, because it's not used yet
      resources "/rooms", AdminRoomController, only: [:index, :delete]
    end
  end
end
