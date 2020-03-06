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
    errors = %{
      invalid_auth_header: %{
        message: "Authorization header missing or malformed",
        code: 401,
      },
      invalid_token: %{
        message: "Token could not be decoded",
        code: 401,
      },
      forbidden: %{
        message: "Not allowed to perform action",
        code: 403,
      },
      not_found: %{
        message: "Resource not found",
        code: 404,
      },
    }

    error = errors[type]

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(error.code, "{\"error\": \"#{error.message}\"}")
      |> halt()
  end
end
