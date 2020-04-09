defmodule KjerSiWeb.CategoryControllerTest do
  use KjerSiWeb.ConnCase

  alias KjerSi.Repo
  alias KjerSi.Accounts.User
  alias KjerSi.Rooms.Category

  setup %{conn: conn} do
    user = Repo.insert!(%User{nickname: "user", uid: "2", is_admin: false})
    category = Repo.insert!(%Category{name: "Test category"})

    conn = TestHelper.login_user(conn, user)

    {:ok, conn: conn, category: category}
  end

  describe "index" do
    test "any user can list categories", %{conn: conn, category: category} do
      category_id = category.id

      %{"data" => [%{"name" => "Test category", "id" => ^category_id}]} =
        conn
        |> get(Routes.category_path(conn, :index))
        |> json_response(200)
    end
  end
end
