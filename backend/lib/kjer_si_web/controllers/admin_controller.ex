defmodule KjerSiWeb.AdminController do
  use KjerSiWeb, :controller

  alias KjerSi.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end
end
