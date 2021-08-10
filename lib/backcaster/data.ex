defmodule Backcaster.SampleData do
  alias Backcaster.Backcast

  def sample do
    %{
      "cards" => %{
#        "ProductName" => %{"title" => "Product Name", "content" => "A sample title", "order" => 1},
#        "IntendedCustomer" => %{"title" => "Intended Customer", "content" => "Quote", "order" => 2},
#        "ProblemsSolved" => %{"title" => "The Problem it solves", "content" => "Best thing ever, changed my life", "order" => 3},
#        "CustomerBenefits" => %{"title" => "Customer benefits", "content" => "Another Category", "order" => 4},
#        "Quote" => %{"title" => "Inspirational Quote", "content" => "Another Category", "order" => 5},
#        "CallToAction" => %{"title" => "Call to Action", "content" => "Another Category", "order" => 6}
      },
      "milestones" => %{
        "1" => %{"date" => Date.add(Date.utc_today(), 4), "title" => "A milestone", "active" => true}
      },
      "images" => %{}
    }
  end

  def possible_sections do
    ["Product Name", "Intended Customer", "The Problem it solves", "Customer benefits", "Inspirational Quote", "Call to Action"]
  end

  def update_field(backcast, title, new_val) do
    update_in(backcast["cards"][title]["content"], fn _old -> new_val end)
  end

  def add_field(backcast, type) do
    put_in(backcast["cards"][type], %{"title" => type, "content" => "", "order" => length(Map.keys(backcast["cards"])) + 1})
  end

  def update_milestone(backcast, id, title, date) do
    update_in(backcast["milestones"][id], fn old -> %{"date" => date, "title" => title, "active" => old["active"]} end)
  end

  def add_milestone(backcast, id, title, date) do
    put_in(backcast["milestones"][id], %{"date" => date, "title" => title, "active" => true})
  end

  def toggle_milestone(backcast, id) do
    update_in(backcast["milestones"][id], fn old -> %{"date" => old["date"], "title" => old["title"], "active" => !old["active"] } end)
  end

  def add_image(backcast, web_path, file_path) do
    id = length(Map.keys(backcast["images"])) + 1
    put_in(backcast["images"]["#{id}"], %{"web_path" => web_path, "file_path" => file_path})
  end

  def delete_image(backcast, img_id) do
    { del_image, new_backcast } = pop_in(backcast["images"]["#{img_id}"])
    File.rm(del_image["file_path"])
    new_backcast
  end

  def persist_board(dat, board) do
    Backcast.update_board(board, %{content: dat})
  end
end