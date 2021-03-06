defmodule KjerSiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use KjerSiWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(KjerSiWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, changeset = %Ecto.Changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(KjerSiWeb.ErrorView)
    |> render(:"422", changeset: changeset)
  end
end
