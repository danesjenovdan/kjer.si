defmodule KjerSiWeb.UserController do
  use KjerSiWeb, :controller

  alias KjerSi.Accounts
  alias KjerSi.Accounts.User
  alias KjerSi.UserHelpers

  action_fallback KjerSiWeb.FallbackController

  def create(conn, %{"uid" => uid}) do
    user = Accounts.get_user_by_uid(uid)

    if user do
      login(conn, user)
    else
      register(conn, uid)
    end
  end

  defp login(conn, user) do
    # It's ok for the salt to be hardcoded
    # https://elixirforum.com/t/phoenix-token-for-api-auth-salt-per-user-or-per-app/13361
    token = Phoenix.Token.sign(KjerSiWeb.Endpoint, "user auth", user.id)

    conn
    |> render("user_with_token.json", %{token: token, user: user})
  end

  defp register(conn, uid) do
    user_params = %{
      "nickname" => UserHelpers.generate_unique_name(),
      "uid" => uid
    }

    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn = Plug.Conn.put_status(conn, :created)

      login(conn, user)
    end
  end

  def self(conn, _params) do
    conn
    |> render("show.json", user: conn.assigns[:current_user])
  end
end
