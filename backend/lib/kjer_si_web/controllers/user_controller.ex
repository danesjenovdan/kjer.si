defmodule KjerSiWeb.UserController do
  use KjerSiWeb, :controller

  alias KjerSi.Accounts
  alias KjerSi.Accounts.User
  alias KjerSi.AccountsHelpers
  alias KjerSi.UserHelpers

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    if Map.has_key?(user_params, "is_active") and not AccountsHelpers.is_admin(conn) do
      AccountsHelpers.return_error(conn, :forbidden)
    else
      with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
        render(conn, "show.json", user: user)
      end
    end
  end

  def generate_username(conn, _params) do
    # generate nickname and assign to user here TODO
    name = UserHelpers.generate_unique_name()
    send_resp(conn, :ok, name)
  end

  def recover_self(conn, %{"uid" => uid}) do
    user = Accounts.get_user_by_uid(uid)

    # It's ok for the salt to be hardcoded
    # https://elixirforum.com/t/phoenix-token-for-api-auth-salt-per-user-or-per-app/13361
    token = Phoenix.Token.sign(KjerSiWeb.Endpoint, "user auth", user.id)

    # Phoenix.Token.verify(MyApp.Endpoint, "user auth", token, max_age: 86400)
    render(conn, "user_with_token.json", %{token: token, user: user})
  end
end
