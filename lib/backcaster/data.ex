defmodule Backcaster.SampleData do
  alias Backcaster.Backcast

  alias Backcaster.Images

  def simple do
    %{
      "template" => List.first(templates()),
      "cards" => %{},
      "milestones" => %{
        "1" => %{"date" => Date.add(Date.utc_today(), 4), "title" => "A milestone", "active" => true, "completed" => Date.utc_today(), "uuid" => UUID.uuid4()}
      },
      "habits" => Habit.gen_habits(),
      "images" => %{}
    }
  end

  def templates() do
    ["personal", "startup", "simple", "freeform", "fivew", "swot",]
  end

  def make_cards do
    possible_sections()
    |> Enum.flat_map(fn section -> %{section => %{"title" => section, "content" => ""}} end)
    |> Map.new()
  end

  def possible_sections do
    ["Project Name", "Project Type", "Intended Audience", "The Problem it solves", "Benefits", "Inspirational Quote", "Call to Action"]
  end

  def update_fields(backcast, %{"content" => content, "category" => category}) do
    update_in(backcast["cards"][category], fn old -> %{"title" => category, "content" => content} end)
  end

  def update_milestone(backcast, id, title, date) do
    update_in(backcast["milestones"][id], fn old -> %{"date" => date, "title" => title, "active" => old["active"], "completed" => completed_at(), "uuid" => old["uuid"] } end)
  end

  def add_milestone(backcast, id, title, date) do
    put_in(backcast["milestones"][id], %{"date" => date, "title" => title, "active" => true, "completed" => completed_at(), "uuid" => UUID.uuid4() })
  end

  def toggle_milestone(backcast, id) do
    update_in(backcast["milestones"][id], fn old -> %{"date" => old["date"], "title" => old["title"], "active" => !old["active"], "completed" => completed_at(), "uuid" => old["uuid"] } end)
  end

  def set_theme(backcast, template) do
    update_in(backcast["template"], fn _old -> template end)
  end

  def completed_at do
    DateTime.utc_now()
  end

  def add_image(backcast, web_path, file_path) do
    id = length(Map.keys(backcast["images"])) + 1
    put_in(backcast["images"]["#{id}"], %{"web_path" => web_path, "file_path" => file_path})
  end

  def delete_image(backcast, img_id) do
    { del_image, new_backcast } = pop_in(backcast["images"]["#{img_id}"])
    Images.delete(Images.url(del_image["web_path"]))
    new_backcast
  end

  def update_habits(backcast, new_habits) do
    Map.put(backcast, "habits", new_habits)
  end


  def persist_board(dat, board) do
    Backcast.update_board(board, %{content: dat})
    Phoenix.PubSub.broadcast(Backcaster.PubSub, "new_edit", {:new_edit, board.name})
  end
end