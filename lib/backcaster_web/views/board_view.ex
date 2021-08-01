defmodule BackcasterWeb.BoardView do
  use BackcasterWeb, :view
  alias BackcasterWeb.BoardView

  def render("index.json", %{boards: boards}) do
    %{data: render_many(boards, BoardView, "board.json")}
  end

  def render("show.json", %{board: board}) do
    %{data: render_one(board, BoardView, "board.json")}
  end

  def render("board.json", %{board: board}) do
    %{
      id: board.id,
      name: board.name,
      content: board.content
    }
  end
end
