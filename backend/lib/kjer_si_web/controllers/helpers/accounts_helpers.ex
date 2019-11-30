defmodule KjerSi.AccountsHelpers do
  import Plug.Conn

  def get_uid(conn) do
    to_string(get_req_header(conn, "uid"))
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
