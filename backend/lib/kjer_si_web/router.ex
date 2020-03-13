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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    resources "/users", UserController, param: "uid", except: [:new, :edit]
=======
    resources "/users", UserController, param: "id", except: [:new, :edit]
>>>>>>> 3234e48bbf98f923ffc0573172e1a941a35a1e17
=======

>>>>>>> ae08ae21f8b8d0e6e55afb1c6da783d52f5ccecd
    resources "/subscriptions", UserRoomController, only: [:index, :create, :show, :delete]

    # resources "/eventsubscriptions", UserEventController, only: [:index, :create, :delete] # commenting out, because it's not used yet

    # registration
    post "/users", UserController, :create
    get "/generate-username", UserController, :generate_username
<<<<<<< HEAD
    get "/categories", RoomController, :categories
<<<<<<< HEAD
    get "/recover-self", UserController, :recover_self
=======
    resources "/users", UserController, param: "uuid", except: [:new, :edit]
    resources "/subscriptions", UserChannelController, param: "channel_id", only: [:create, :delete]
    resources "/events", EventController, param: "id", only: [:index, :show, :create]
>>>>>>> 3d458a62738855956ff32c424c1eaf0462e31d1b
=======
    post "/recover-self", UserController, :recover_self
>>>>>>> 3234e48bbf98f923ffc0573172e1a941a35a1e17
=======
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
>>>>>>> ae08ae21f8b8d0e6e55afb1c6da783d52f5ccecd
  end
end
