defmodule Habits do
  use Surface.LiveComponent

  def mount(socket) do

    visible_habits =
      Habit.get_habits()
      |> Enum.filter(fn habit -> Habit.is_due(habit) end)

    socket =
      socket
      |> assign(:habits, visible_habits)
    {:ok, socket}
  end

end