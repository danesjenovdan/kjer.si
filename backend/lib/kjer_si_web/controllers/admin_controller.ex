defmodule KjerSiWeb.AdminController do
  use KjerSiWeb, :controller

  alias KjerSi.Accounts

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
