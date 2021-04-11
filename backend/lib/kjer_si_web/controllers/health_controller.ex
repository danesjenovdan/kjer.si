defmodule KjerSiWeb.HealthController do
  use KjerSiWeb, :controller

  action_fallback KjerSiWeb.FallbackController

  def index(conn, _params) do
    conn
    |> put_view(KjerSiWeb.HealthView)
    |> render("index.json")
  end
end
