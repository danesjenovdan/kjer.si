defmodule KjerSiWeb.CategoryView do
  use KjerSiWeb, :view
  alias KjerSiWeb.CategoryView

  def render("show.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{
      name: category.name,
      id: category.id
    }
  end
end
