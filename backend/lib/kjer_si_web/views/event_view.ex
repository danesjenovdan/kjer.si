defmodule KjerSiWeb.EventView do
  use KjerSiWeb, :view
  alias KjerSiWeb.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      name: event.name,
<<<<<<< HEAD
      datetime: event.datetime,
      description: event.description,
      location: event.location,
      max_attending: event.max_attending,
      user_id: event.user_id,
      room_id: event.room_id
    }
  end
end
=======
      description: event.description
    }
  end
end
>>>>>>> 3d458a62738855956ff32c424c1eaf0462e31d1b
