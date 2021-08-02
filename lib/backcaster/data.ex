defmodule Backcaster.SampleData do
  alias Backcaster.Backcast

  def sample do
    %{
      "cards" => %{
        "Title" => %{"title" => "Title", "content" => "A sample title", "order" => 1},
        "Quote" => %{"title" => "Quote", "content" => "Quote", "order" => 2},
        "CustomerComments" => %{"title" => "CustomerComments", "content" => "Best thing ever, changed my life", "order" => 3},
        "Another" => %{"title" => "Another", "content" => "Another Category", "order" => 4}
      },
      "milestones" => %{
        "1" => %{"date" => Date.add(Date.utc_today(), 4), "title" => "A milestone"}
      }
    }
  end

  def possible_sections do
    ["A section", "B section", "C section", "RANDOM"]
  end

  def update_field(backcast, title, new_val) do
    update_in(backcast["cards"][title]["content"], fn _old -> new_val end)
  end

  def add_field(backcast, type) do
    put_in(backcast["cards"][type], %{"title" => type, "content" => "", "order" => length(Map.keys(backcast["cards"])) + 1})
  end

  def update_milestone(backcast, id, title, date) do
    update_in(backcast["milestones"][id], fn _old -> %{"date" => date, "title" => title} end)
  end

  def persist_board(dat, board) do
    Backcast.update_board(board, %{content: dat})
  end
end