defmodule KjerSiWeb.Plugs.Auth do
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
