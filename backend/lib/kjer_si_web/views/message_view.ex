defmodule KjerSiWeb.MessageView do
  use KjerSiWeb, :view

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      content: message.content,
      room_id: message.room_id,
      user_id: message.user.id,
      user_nickname: message.user.nickname,
      created: message.inserted_at,
    }
  end
end
