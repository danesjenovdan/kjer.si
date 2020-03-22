defmodule KjerSiWeb.MessageView do
  use KjerSiWeb, :view
  alias KjerSiWeb.MessageView

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      content: message.content,
      room_id: message.room_id,
      user_id: message.user.id,
      user_nickname: message.user.nickname,
      created: message.inserted_at
    }
  end
end
