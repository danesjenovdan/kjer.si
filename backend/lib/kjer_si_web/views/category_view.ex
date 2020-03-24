defmodule KjerSiWeb.CategoryView do
  use KjerSiWeb, :view
  alias KjerSiWeb.CategoryView

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, CategoryView, "category.json")}
  end

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
