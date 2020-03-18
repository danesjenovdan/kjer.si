defmodule KjerSiWeb.Plugs.Auth do
  import Plug.Conn

  alias KjerSi.AccountsHelpers
  alias KjerSi.Accounts.User

  def init(default), do: default

  def call(conn, "is_admin") do
    if AccountsHelpers.is_admin(conn) do
      conn
    else
      AccountsHelpers.return_error(conn, :forbidden)
    end
  end

  def call(conn, "is_logged_in") do
    case AccountsHelpers.get_user_from_conn(conn) do
      {:ok, current_user} ->
        conn
        |> assign(:current_user, current_user)

      {:error, error_type} ->
        AccountsHelpers.return_error(conn, error_type)
    end
  end

  def call(%{params: %{"id" => user_id}} = conn, "is_self") do
    with {:ok, %User{} = user} <- AccountsHelpers.get_auth_user(conn) do
      if user_id == user.id do
        conn
      else
        AccountsHelpers.return_error(conn, :forbidden)
      end
    end
  end
end
