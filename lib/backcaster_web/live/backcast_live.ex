defmodule BackcasterWeb.BackcastLive do
  use Surface.LiveView

  alias Backcaster.SampleData
  alias Backcaster.Backcast

  @save_time 5000 # check to see if we should save to DB every 5 seconds

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, @save_time)
    board = Backcast.get_or_create_board!(id, SampleData.sample())
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

  def handle_event("update_field", %{"vals" => %{"new_value" => new_val, "title" => title}}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.update_field(socket.assigns.backcast, title, new_val))
      |> assign(:should_save, true)
    {:noreply, socket}
  end

  def handle_event("add_field", %{"type" => type}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.add_field(socket.assigns.backcast, type))
      |> assign(:should_save, true)
    {:noreply, socket}
  end

  def handle_event("delete_field", %{"label" => label}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.delete_field(socket.assigns.backcast, label))
      |> assign(:should_save, true)
    {:noreply, socket}
  end


  def handle_event("update_milestone", %{"vals" => %{"date" => date, "title" => title, "id" => id}}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.update_milestone(socket.assigns.backcast, id, title, date))
      |> assign(:should_save, true)
    {:noreply, socket}
  end

  def handle_event("create_milestone", %{"vals" => %{"date" => date, "title" => title, "id" => id}}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.add_milestone(socket.assigns.backcast, id, title, date))
      |> assign(:should_save, true)
    {:noreply, socket}
  end

  def handle_event("delete_image", %{"id" => img_id}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.delete_image(socket.assigns.backcast, img_id))

    Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board) end)
    {:noreply, socket}
  end



  def handle_event("change_active", %{"id" => id}, socket) do
    socket =
      socket
    |> assign(:backcast, SampleData.toggle_milestone(socket.assigns.backcast, id))
    |> assign(:should_save, true)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{"web_path" => web_path, "file_path" => file_path, name: "store_image"}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.add_image(socket.assigns.backcast, web_path, file_path))

    SampleData.persist_board(socket.assigns.backcast, socket.assigns.board)

    {:noreply, socket}
  end

  def sort_milestones(milestones) do
    Enum.sort(milestones, fn {_k1, v1}, {_k2, v2} -> v1["date"] <= v2["date"] end)
  end


end