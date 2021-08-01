defmodule Backcaster.SampleData do
  alias Backcaster.Backcast

  def sample(_id) do
    %{
      "Title" => %{"title" => "Title", "content" => "A sample title", "order" => 1},
      "Quote" => %{"title" => "Quote", "content" => "Quote", "order" => 2},
      "CustomerComments" => %{"title" => "CustomerComments", "content" => "Best thing ever, changed my life", "order" => 3},
      "Another" => %{"title" => "Another", "content" => "Another Category", "order" => 4}
    }
  end

  def possible_sections do
    ["A section", "B section", "C section"]
  end

  def persist_board(dat, board) do
    Backcast.update_board(board, %{content: dat})
  end
end