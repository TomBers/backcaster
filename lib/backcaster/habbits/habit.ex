defmodule Habit do
  @enforce_keys [:name, :updated_at]
  defstruct [:name, :created_at, :updated_at, :uuid, is_deleted: false, update_freq: :daily, history: []]

  def gen_habits do
    %{
      "1" => new_habit("1. Daily", "daily"),
      "2" => new_habit("2. Weekly", "weekly"),
      "3" => new_habit("3. Monthly", "monthly")
    }
  end

  def get_visible_habits(habits) do
    habits |> Enum.filter(fn {_id, habit} -> Habit.is_due(habit) and !habit.is_deleted end) |> Map.new()
  end

  def is_due(%Habit{update_freq: :daily, updated_at: updated_at}) do
    Date.diff(Date.utc_today(), updated_at) >= 1
  end

  def is_due(%Habit{update_freq: :weekly, updated_at: updated_at}) do
    Date.diff(Date.utc_today(), updated_at) >= 7
  end

  def is_due(%Habit{update_freq: :monthly, updated_at: updated_at}) do
    Date.diff(Date.utc_today(), updated_at) >= 31
  end

  def complete_habit(habits, id) do
    update_in(habits[id], fn old -> %Habit{ name: old.name, update_freq: old.update_freq, updated_at: Date.utc_today(), created_at: old.created_at, uuid: old.uuid, is_deleted: old.is_deleted, history: old.history ++ [Date.utc_today()] } end)
  end

  def add_new_habit(habits, title, freq) do
    key = length(Map.keys(habits)) + 1
    Map.put(habits, "#{key}", new_habit(title, freq))
  end

  def new_habit(name, "daily") do
    habit(name, :daily, Date.add(Date.utc_today(), -1))
  end

  def new_habit(name, "weekly") do
    habit(name, :weekly, Date.add(Date.utc_today(), -7))
  end

  def new_habit(name, "monthly") do
    habit(name, :monthly, Date.add(Date.utc_today(), -31))
  end

  def habit(name, update_freq, updated_at) do
    %Habit{name: name, created_at: Date.utc_today(), updated_at: updated_at, update_freq: update_freq, uuid: UUID.uuid4() }
  end


end