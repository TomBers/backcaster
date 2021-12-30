defmodule BackcasterWeb.BlogView do
  use BackcasterWeb, :view

  def find_article_by_id(id) do
    Blog.articles()
    |> Enum.find(fn article -> article.href == id end)
  end

  def get_articles(nil) do
    Blog.articles()
  end

  def get_articles(tag) do
    Blog.articles() |> Enum.filter(fn article -> Enum.any?(article.tags, fn x -> x == tag end) end)
  end

end
