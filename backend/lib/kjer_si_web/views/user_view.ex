defmodule KjerSiWeb.UserView do
  use KjerSiWeb, :view

  def render("show.json", %{user: user}) do
    %{data: %{id: user.id, nickname: user.nickname, uid: user.uid, is_active: user.is_active}}
  end

  def render("user_with_token.json", %{token: token, user: user}) do
    %{
      id: user.id,
      nickname: user.nickname,
      uid: user.uid,
      is_active: user.is_active,
      token: token
    }
  end

  def render("user_id.json", %{user: user}) do
    user.id
  end

  def render("user_nickname.json", %{user: user}) do
    user.nickname
  end
end
