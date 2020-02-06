defmodule KjerSi.AccountsHelpers do
  import Plug.Conn

  alias KjerSi.Accounts

  defp get_token(conn) do
    header = conn |> get_req_header("authorization") |> to_string
    match = Regex.named_captures(~r/^Bearer (?<token>[[:ascii:]]+)/, header)

    if match do
      {:ok, match["token"]}
    else
      {:error, :invalid_auth_header}
    end
  end

  defp get_user_id(conn) do
    with {:ok, token} <- get_token(conn) do
      case Phoenix.Token.verify(KjerSiWeb.Endpoint, "user auth", token, max_age: 86400) do
        {:ok, user_id} -> {:ok, user_id}
        {:error, _} -> {:error, :invalid_token}
      end
    end
  end

  defp get_user(conn, preload \\ []) do
    with {:ok, user_id} <- get_user_id(conn) do
      user = Accounts.get_user_with_preload(user_id, preload)
      if user do
        {:ok, user}
      else
        {:error, :invalid_user}
      end
    end
  end

  def get_auth_user(conn, preload \\ []) do
    case get_user(conn, preload) do
      {:ok, user} -> {:ok, user}
      {:error, error_type} -> return_error(conn, error_type)
    end
  end

  def is_admin(conn) do
    case get_user(conn) do
      {:ok, user} -> user.is_admin
      {:error, error_type} -> return_error(conn, error_type)
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
