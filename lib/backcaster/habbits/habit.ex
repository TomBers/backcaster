defmodule Habit do

  def gen_habits do
    %{
      "1" => new_habit("1. Daily", "daily"),
      "2" => new_habit("2. Weekly", "weekly"),
      "3" => new_habit("3. Monthly", "monthly")
    }
  end

  def get_visible_habits(habits) do
    habits |> Enum.filter(fn {_id, habit} -> Habit.is_due(habit) and !habit["is_deleted"] end) |> Map.new()
  end

  def is_due(%{"update_freq" => "daily", "updated_at" => updated_at}) do
    Date.diff(Date.utc_today(), Date.from_iso8601!(updated_at)) >= 1
  end

  def is_due(%{"update_freq" => "weekly", "updated_at" => updated_at}) do
    Date.diff(Date.utc_today(), Date.from_iso8601!(updated_at)) >= 7
  end

  def is_due(%{"update_freq" => "monthly", "updated_at" => updated_at}) do
    Date.diff(Date.utc_today(), Date.from_iso8601!(updated_at)) >= 31
  end

  def complete_habit(habits, id, set_delete) do
    update_in(habits[id], fn old -> %{"name" => old["name"], "created_at" => old["created_at"], "updated_at" => Date.utc_today() |> Date.to_string, "update_freq" => old["update_freq"], "uuid" => old["uuid"], "is_deleted" => set_delete, "history" => old["history"] ++ [Date.utc_today()] } end)
  end


  def add_new_habit(habits, title, freq) do
    key = length(Map.keys(habits)) + 1
    Map.put(habits, "#{key}", new_habit(title, freq))
  end

  def new_habit(name, "daily") do
    habit(name, "daily", Date.add(Date.utc_today(), -1))
  end

  def new_habit(name, "weekly") do
    habit(name, "weekly", Date.add(Date.utc_today(), -7))
  end

  def new_habit(name, "monthly") do
    habit(name, "monthly", Date.add(Date.utc_today(), -31))
  end

  def habit(name, update_freq, updated_at) do
    %{"name" => name, "created_at" => Date.utc_today() |> Date.to_string, "updated_at" => updated_at |> Date.to_string, "update_freq" => update_freq, "uuid" => UUID.uuid4(), "is_deleted" => false, "history" => [] }
  end


end