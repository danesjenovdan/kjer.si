defmodule KjerSiWeb.PageController do
  use KjerSiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
