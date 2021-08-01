defmodule BackcasterWeb.BackcastLive do
  use Surface.LiveView

  alias Backcaster.SampleData

  def mount(%{"id" => id}, _session, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.sample(id))
    {:ok, socket}
  end

  def handle_event("update_field", %{"vals" => %{"new value" => new_val, "title" => title}}, socket) do
    new_backcast = Map.replace(socket.assigns.backcast, title, new_val)
    {:noreply, assign(socket, :backcast, new_backcast)}
  end

  def handle_event("add_field", %{"type" => type}, socket) do
    new_backcast = Map.put_new(socket.assigns.backcast, type, "")
    {:noreply, assign(socket, :backcast, new_backcast)}
  end


end