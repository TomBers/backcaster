defmodule Habits do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, Select, Label, Field}

  prop habits, :map
  prop parent_pid, :string

  data is_open, :boolean, default: false
  data show_form, :boolean, default: false
  data show_delete, :boolean, default: false
  data vals, :map, default: %{"name" => "", "freq" => ""}

  def mount(socket) do
    {:ok, socket}
  end

  def visible(habits) do
    Habit.get_visible_habits(habits)
  end

  def handle_event("open_habits", _, socket) do
    {:noreply, update(socket, :is_open, fn _ -> !socket.assigns.is_open end)}
  end

  def handle_event("delete_habits", _, socket) do
    {:noreply, update(socket, :show_delete, fn _ -> !socket.assigns.show_delete end)}
  end

  def handle_event("complete_habit", %{"habit-id" => id, "set-delete" => set_delete_str}, socket) do
    set_delete = if set_delete_str == "true" do true else false end
    new_habits =
      socket.assigns.habits
      |> Habit.complete_habit(id, set_delete)

    save_habits(socket.assigns.parent_pid, new_habits)

    {:noreply, socket}
  end

  def handle_event("add_new_habit", _, socket) do
    {:noreply, update(socket, :show_form, fn _ -> !socket.assigns.show_form end)}
  end

  def handle_event("submit_new_habit", %{"vals" => %{"freq" => freq, "title" => title}}, socket) do

    new_habits = Habit.add_new_habit(socket.assigns.habits, title, freq)

#   Save new habits to the board
    save_habits(socket.assigns.parent_pid, new_habits)

    {:noreply, update(socket, :show_form, fn _ -> false end)}
  end

  def save_habits(parent_pid, new_habits) do
    send(parent_pid, %{"updated_habits" => new_habits})
  end


end