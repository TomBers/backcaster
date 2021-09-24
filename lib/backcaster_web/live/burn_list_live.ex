defmodule BackcasterWeb.BurnListLive do
  use Surface.LiveView

  alias Surface.Components.Form
  alias Surface.Components.Form.{RangeInput}

  def mount(_params, _session, socket) do

    socket =
      socket
      |> assign(:history, Backcaster.Todos.sample())

    {:ok, socket}
  end

  def handle_event("set_current", %{"current" => [current]}, socket) do
    index = length(socket.assigns.history.past) - String.to_integer(current)
    socket =
      socket
      |> assign(:history, BurnListHistory.set_current(socket.assigns.history, index))
    {:noreply, socket}
  end

  def handle_info(%{"edit_item" => %{"content" => text, "uuid" => uuid}}, socket) do
    history = socket.assigns.history
    old_item =
      Enum.find(history.current.items, fn x -> x.uuid == uuid end)
    socket =
      socket
      |> assign(:history, BurnListHistory.edit_item(history, old_item, BurnListItem.make_item(text)))

    {:noreply, socket}
  end

end