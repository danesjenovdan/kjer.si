defmodule KjerSiWeb.Router do
  use KjerSiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    use Plug.Debugger # TODO Disable before production
  end

  scope "/api", KjerSiWeb do
    pipe_through :api
<<<<<<< HEAD
<<<<<<< HEAD
    resources "/users", UserController, param: "uid", except: [:new, :edit]
=======
    resources "/users", UserController, param: "id", except: [:new, :edit]
>>>>>>> 3234e48bbf98f923ffc0573172e1a941a35a1e17
    resources "/subscriptions", UserRoomController, only: [:index, :create, :show, :delete]
    resources "/events", EventController, param: "uid", only: [:index, :show, :create, :update]
    resources "/eventsubscriptions", UserEventController, only: [:index, :create, :delete]
    resources "/rooms", RoomController, only: [:create, :delete, :show]

    post "/map/rooms", MapController, :get_rooms_in_radius
    get "/generate-username", UserController, :generate_username
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
  end
end
