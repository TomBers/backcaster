defmodule Habit do
  @enforce_keys [:name, :updated_at]
  defstruct [:name, :updated_at, update_freq: :daily]

  def get_habits do
    [
      gen_rand(),
      gen_rand(),
      gen_rand
    ]
  end

  def gen_rand do
    %Habit{name: "a habbit", updated_at: Date.add(Date.utc_today(), Enum.random([-3,-7,-400])), update_freq: Enum.random([:daily, :weekly ,:monthly])}
  end

  def is_due(%Habit{name: _name, update_freq: :daily, updated_at: updated_at}) do
    Date.diff(Date.utc_today(), updated_at) >= 1
  end

  def is_due(%Habit{name: _name, update_freq: :weekly, updated_at: updated_at}) do
    Date.diff(Date.utc_today(), updated_at) >= 7
  end

  def is_due(%Habit{name: _name, update_freq: :monthly, updated_at: updated_at}) do
    Date.diff(Date.utc_today(), updated_at) >= 31
  end

end