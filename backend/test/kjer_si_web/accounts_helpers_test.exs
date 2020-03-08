defmodule KjerSiWeb.AccountsHelpersTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User
  alias KjerSi.AccountsHelpers

  setup %{conn: conn} do
    {:ok, user} = Repo.insert(%User{nickname: "user", uid: "2", is_admin: false})

    {:ok, conn: conn, user: user}
  end

  describe "get_auth_user" do
    test "not providing an auth header returns error", %{conn: conn} do
      %{"error" => "Authorization header missing or malformed"} =
        conn
        |> AccountsHelpers.get_auth_user()
        |> json_response(401)
    end

    test "using an invalid token returns error", %{conn: conn} do
      %{"error" => "Token could not be decoded"} =
        conn
        |> put_req_header("authorization", "Bearer Schmearer")
        |> AccountsHelpers.get_auth_user()
        |> json_response(401)
    end

    test "using a valid token with an non-existent user id returns error", %{conn: conn} do
      non_existent_id = "f4f4f4f4-f4f4-f4f4-f4f4-f4f4f4f4f4f4"
      valid_token = Phoenix.Token.sign(KjerSiWeb.Endpoint, "user auth", non_existent_id)

      %{"error" => "User does not exist"} =
        conn
        |> put_req_header("authorization", "Bearer #{valid_token}")
        |> AccountsHelpers.get_auth_user()
        |> json_response(403)
    end

    test "using a valid token with a valid user id returns user", %{conn: conn, user: user} do
      valid_token = Phoenix.Token.sign(KjerSiWeb.Endpoint, "user auth", user.id)

      {:ok, returned_user} =
        conn
        |> put_req_header("authorization", "Bearer #{valid_token}")
        |> AccountsHelpers.get_auth_user()

      assert returned_user == user
    end
  end
end
