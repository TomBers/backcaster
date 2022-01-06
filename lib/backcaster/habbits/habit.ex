defmodule Habit do
  @enforce_keys [:name, :updated_at]
  defstruct [:name, :updated_at, :uuid, is_deleted: false, update_freq: :daily]

  def gen_habits do
    %{
      "1" => gen_rand("one"),
      "2" => gen_rand("two"),
      "3" => gen_rand("three")
    }
  end

  def get_visible_habits(habits) do
    habits |> Enum.filter(fn {_id, habit} -> Habit.is_due(habit) and !habit.is_deleted end) |> Map.new()
  end

  def gen_rand(name) do
    %Habit{name: name, updated_at: Date.add(Date.utc_today(), Enum.random([-3,-7,-400])), update_freq: Enum.random([:daily, :weekly ,:monthly]), uuid: UUID.uuid4() }
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
    update_in(habits[id], fn old -> %Habit{name: "complete", update_freq: old.update_freq, uuid: old.uuid, updated_at: Date.utc_today() } end)
  end

  def add_new_habit(habits, title, freq) do
    key = length(Map.keys(habits)) + 1
    Map.put(habits, "#{key}", new_habit(title, freq))
  end

  def new_habit(name, "daily") do
    %Habit{name: name, updated_at: Date.add(Date.utc_today(), -1), update_freq: :daily, uuid: UUID.uuid4() }
  end

  def new_habit(name, "weekly") do
    %Habit{name: name, updated_at: Date.add(Date.utc_today(), -7), update_freq: :weekly, uuid: UUID.uuid4() }
  end

  def new_habit(name, "monthly") do
    %Habit{name: name, updated_at: Date.add(Date.utc_today(), -31), update_freq: :monthly, uuid: UUID.uuid4() }
  end

end