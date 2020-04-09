defmodule KjerSiWeb.UserView do
  use KjerSiWeb, :view

  def render("show.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        nickname: user.nickname,
        uid: user.uid,
        isActive: user.is_active,
        isAdmin: user.is_admin,
        createdAt: user.inserted_at
      }
    }
  end

  def render("user_with_token.json", %{token: token, user: user}) do
    %{
      data: %{
        id: user.id,
        nickname: user.nickname,
        uid: user.uid,
        isActive: user.is_active,
        isAdmin: user.is_admin,
        createdAt: user.inserted_at,
        token: token
      }
    }
  end

  def render("user_id.json", %{user: user}) do
    user.id
  end

  def render("user_nickname.json", %{user: user}) do
    user.nickname
  end
end
