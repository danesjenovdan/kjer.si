defmodule KjerSiWeb.CategoryController do
  use KjerSiWeb, :controller

  alias KjerSi.Rooms

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    conn
    |> put_view(KjerSiWeb.CategoryView)
    |> render("index.json", categories: Rooms.list_categories())
  end
end
