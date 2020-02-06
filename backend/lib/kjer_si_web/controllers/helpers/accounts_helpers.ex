defmodule KjerSi.AccountsHelpers do
  import Plug.Conn

  alias KjerSi.Accounts

  def get_auth(conn) do
    conn |> get_req_header("authorization") |> to_string
  end

  def get_uid(conn) do
    conn |> get_auth # pipe will continue at some point
  end

  def get_auth_user(conn, preload \\ []) do
    user = conn |> get_uid |> Accounts.get_user_with_preload(preload)
    if user do
      {:ok, user}
    else
      return_unauthorized(conn)
    end
  end

  def is_admin(conn) do
    user = conn |> get_uid |> Accounts.get_user_by_uid
    if user do
      user.is_admin
    else
      false
    end
  end

  def return_unauthorized(conn) do
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(400, "{\"error\": \"unauthorized\"}")
  end

  def return_not_found(conn) do
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(:not_found, "{\"error\": \"not found\"}")
  end
end
