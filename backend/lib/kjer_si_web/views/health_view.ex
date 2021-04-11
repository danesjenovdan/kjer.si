defmodule KjerSiWeb.HealthView do
  use KjerSiWeb, :view

  def render("index.json", _) do
    %{ok: true}
  end
end
