defmodule Backcaster.SampleData do
  alias Backcaster.Backcast

  alias Backcaster.Images

  def sample do
    %{
      "cards" => %{
        "Project Name" => %{"title" => "Project Name", "content" => "Project Name", "order" => 1}
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

  def update_fields(backcast, fields) do
    new_fields =
      fields
      |> Enum.map(fn {k,v} -> params = String.split(k, "__"); %{"title" => List.first(params), "content" => v, "order" => String.to_integer(List.last(params))} end)
      |> Map.new(fn e -> {e["title"], e} end)

    update_in(backcast["cards"], fn old -> new_fields end)
  end

  def add_field(backcast, type) do
    case backcast["cards"][type] do
      nil -> put_in(backcast["cards"][type], %{"title" => type, "content" => "", "order" => get_field_order(backcast["cards"]) })
      _ -> backcast
    end
  end


  def get_field_order(cards) do
    if length(Map.keys(cards)) > 0 do
      {_k, max} = cards
        |> Enum.max_by(fn {k, v} -> v["order"]  end)
      max["order"] + 1
    else
      1
      end
  end

  def delete_field(backcast, label) do
    { _old, new_backcast } = pop_in(backcast["cards"][label])
   new_backcast
  end

  def update_milestone(backcast, id, title, date) do
    update_in(backcast["milestones"][id], fn old -> %{"date" => date, "title" => title, "active" => old["active"], "completed" => completed_at() } end)
  end

  def add_milestone(backcast, id, title, date) do
    put_in(backcast["milestones"][id], %{"date" => date, "title" => title, "active" => true, "completed" => completed_at() })
  end

  def toggle_milestone(backcast, id) do
    update_in(backcast["milestones"][id], fn old -> %{"date" => old["date"], "title" => old["title"], "active" => !old["active"], "completed" => completed_at() } end)
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

  def persist_board(dat, board) do
    Backcast.update_board(board, %{content: dat})
  end
end