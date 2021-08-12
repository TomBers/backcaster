defmodule Backcaster.SampleData do
  alias Backcaster.Backcast

  def sample do
    %{
      "cards" => %{
        "Project Name" => %{"title" => "Product Name", "content" => "Project Name", "order" => 1}
      },
      "milestones" => %{
        "1" => %{"date" => Date.add(Date.utc_today(), 4), "title" => "A milestone", "active" => true, "completed" => Date.utc_today()}
      },
      "images" => %{}
    }
  end

  def possible_sections do
    ["Project Name", "Project Type", "Intended Audience", "The Problem it solves", "Benefits", "Inspirational Quote", "Call to Action"]
  end

  def update_field(backcast, title, new_val) do
    update_in(backcast["cards"][title]["content"], fn _old -> new_val end)
  end

  def add_field(backcast, type) do
    put_in(backcast["cards"][type], %{"title" => type, "content" => "", "order" => length(Map.keys(backcast["cards"])) + 1})
  end

  def delete_field(backcast, label) do
    { _old, new_backcast } = pop_in(backcast["cards"][label])
   new_backcast
  end

  def update_milestone(backcast, id, title, date) do
    update_in(backcast["milestones"][id], fn old -> %{"date" => date, "title" => title, "active" => old["active"], "completed" => Date.utc_today() } end)
  end

  def add_milestone(backcast, id, title, date) do
    put_in(backcast["milestones"][id], %{"date" => date, "title" => title, "active" => true, "completed" => Date.utc_today()})
  end

  def toggle_milestone(backcast, id) do
    update_in(backcast["milestones"][id], fn old -> %{"date" => old["date"], "title" => old["title"], "active" => !old["active"], "completed" => Date.utc_today() } end)
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