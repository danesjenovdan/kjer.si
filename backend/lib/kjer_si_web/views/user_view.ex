defmodule KjerSiWeb.UserView do
  use KjerSiWeb, :view
  alias KjerSiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      nickname: user.nickname,
      uid: user.uid,
      is_active: user.is_active}
  end

  def render("user_with_token.json", %{token: token, user: user}) do
    %{id: user.id,
      nickname: user.nickname,
      uid: user.uid,
      is_active: user.is_active,
      token: token}
  end

  def render("user_id.json", %{user: user}) do
    user.id
  end

  def render("user_nickname.json", %{user: user}) do
    user.nickname
  end
end
