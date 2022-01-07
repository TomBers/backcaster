defmodule Habits do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, Select, Label, Field}

  data is_open, :boolean, default: true
  data show_form, :boolean, default: false
  data show_delete, :boolean, default: true
  data vals, :map, default: %{"name" => "", "freq" => ""}

  def mount(socket) do

    visible_habits =
      Habit.gen_habits()
      |> Habit.get_visible_habits()

    socket =
      socket
      |> assign(:habits, visible_habits)
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
    {:noreply, update(socket, :habits, fn _ -> new_habits end)}
  end

  def handle_event("add_new_habit", _, socket) do
    {:noreply, update(socket, :show_form, fn _ -> !socket.assigns.show_form end)}
  end

  def handle_event("submit_new_habit", %{"vals" => %{"freq" => freq, "title" => title}}, socket) do

    new_habits = Habit.add_new_habit(socket.assigns.habits, title, freq)

    socket =
      socket
      |> update(:show_form, fn _ -> false end)
      |> update(:habits, fn _ -> new_habits end)

    {:noreply, socket}
  end


end