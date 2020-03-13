defmodule KjerSiWeb.Admin.AdminUserController do
  use KjerSiWeb, :controller

  alias KjerSi.Accounts
  alias KjerSi.Accounts.User

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end
end
