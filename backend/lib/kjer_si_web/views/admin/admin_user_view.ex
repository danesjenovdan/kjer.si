defmodule KjerSiWeb.Admin.AdminUserView do
  use KjerSiWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json", as: :user)}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json", as: :user)}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, nickname: user.nickname, uid: user.uid, is_active: user.is_active}
  end
end
