defmodule BackcasterWeb.BackcastLive do
  use Surface.LiveView

  alias Backcaster.SampleData
  alias Backcaster.Backcast

  @save_time 5000 # check to see if we should save to DB every 5 seconds

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, @save_time)
    board = Backcast.get_or_create_board!(id)
    socket =
      socket
      |> assign(:backcast, board.content)
      |> assign(:board, board)
      |> assign(:should_save, false)


    {:ok, socket}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, @save_time)
    if socket.assigns.should_save do
      Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board) end)
    end
    {:noreply, assign(socket, :should_save, false)}
  end

  def handle_event("update_field", %{"vals" => %{"new value" => new_val, "title" => title}}, socket) do
    new_backcast = Map.update!(socket.assigns.backcast, title, fn existing -> %{"title" => existing["title"], "content" => new_val, "order" => existing["order"]} end)
    socket =
      socket
      |> assign(:backcast, new_backcast)
      |> assign(:should_save, true)
    {:noreply, socket}
  end

  def handle_event("add_field", %{"type" => type}, socket) do
    new_backcast = Map.put_new(socket.assigns.backcast, type, %{"title" => type, "content" => "", "order" => length(Map.keys(socket.assigns.backcast)) + 1})
    socket =
      socket
      |> assign(:backcast, new_backcast)
      |> assign(:should_save, true)
    {:noreply, socket}
  end


end