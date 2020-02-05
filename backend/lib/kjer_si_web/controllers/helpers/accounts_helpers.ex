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

  def return_error(conn, type) do
    messages = %{
      invalid_auth_header: "Authorization header missing or malformed",
      invalid_token: "Token could not be decoded",
      invalid_user: "User not found",
      unauthorized: "Not authorized to perform action",
      not_found: "Resource not found",
    }

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(400, "{\"error\": \"#{messages[type]}\"}")
  end
end
