defmodule BackcasterWeb.BlogController do
  use BackcasterWeb, :controller

  action_fallback BackcasterWeb.FallbackController

  def index(conn, params) do
    tag = Map.get(params, "tag", nil)
    render(conn, "index.html", tag: tag, load_graph: false)
  end

  def article(conn, %{"id" => id}) do
    article = BackcasterWeb.BlogView.find_article_by_id(id)
    render(conn, article.href, load_graph: article.has_graph)
  end

end
