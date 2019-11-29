defmodule KjerSiWeb.Router do
  use KjerSiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KjerSiWeb do
    pipe_through :api
    resources "/users", UserController, param: "uuid", except: [:new, :edit]
  end
end
