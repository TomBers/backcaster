defmodule BackcasterWeb.BackcastLive do
  use Surface.LiveView

  alias Backcaster.SampleData
  alias Backcaster.Backcast

  def mount(%{"id" => id} = params, _session, socket) do
    if connected?(socket) do
      Backcast.subscribe()
    end

    theme = Map.get(params, "theme", "lofi")

    goal_date =
      Date.utc_today()
      |> Date.add(44)

    {_created, board} = Backcast.get_or_create_board!(id, goal_date, SampleData.simple())

#    IO.inspect(board)

    socket =
      socket
      |> assign(:backcast, board.content)
      |> assign(:board, board)
      |> assign(:theme, theme)
      |> assign(:show_image_processing, false)
      |> assign(:active_tab, "description")

    {:ok, socket}
  end
  
#  Handles updating problem statement, the handle_info is because we want to close the field after editing, so a message is sent
  def handle_info(%{"vals" => fields}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.update_fields(socket.assigns.backcast, fields))
      Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board) end)
      
    {:noreply, socket}
  end

  def handle_info(%{"due_date" => %{"new_date" => new_date}}, socket) do
    {:ok, board} = Backcast.update_board(socket.assigns.board, %{goal_date: new_date})
    {:noreply, assign(socket, :board, board)}
  end

  def handle_info(%{"updated_habits" => new_habits}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.update_habits(socket.assigns.backcast, new_habits))

    Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board) end)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_edit, board_id}, socket) do
    if board_id == socket.assigns.board.name do
      board = Backcast.get_board_by_name!(socket.assigns.board.name)
      socket =
        socket
        |> assign(:backcast, board.content)
        |> assign(:board, board)
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end


  def handle_event("update_milestone", %{"vals" => %{"date" => date, "title" => title, "id" => id}}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.update_milestone(socket.assigns.backcast, id, title, date))

      Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board) end)
    {:noreply, socket}
  end

  def handle_event("create_milestone", %{"vals" => %{"date" => date, "title" => title, "id" => id}}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.add_milestone(socket.assigns.backcast, id, title, date))

      Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board) end)
    {:noreply, socket}
  end

  def handle_event("delete_image", %{"id" => img_id}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.delete_image(socket.assigns.backcast, img_id))

    Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board) end)

    {:noreply, socket}
  end

  def handle_event("change_template", %{"theme" => %{"template" => template}}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.set_theme(socket.assigns.backcast, template))

      Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board) end)

    {:noreply, socket}
  end



  def handle_event("change_active", %{"id" => id}, socket) do
    socket =
      socket
    |> assign(:backcast, SampleData.toggle_milestone(socket.assigns.backcast, id))

    Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board) end)

    {:noreply, socket}
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, socket |> assign(:active_tab, tab)}
  end

  @impl true
  def handle_info(%{"web_path" => web_path, "file_path" => file_path, name: "store_image"}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.add_image(socket.assigns.backcast, web_path, file_path))

    SampleData.persist_board(socket.assigns.backcast, socket.assigns.board)

    {:noreply, assign(socket, :show_image_processing, true)}
  end

  def sort_milestones(milestones) do
    Enum.sort(milestones, fn {_k1, v1}, {_k2, v2} -> v1["date"] <= v2["date"] end)
  end

  def count_milestones(milestones, cond) do
    milestones
    |> Enum.filter(fn {k, m} -> m["active"] == cond end)
    |> length()
  end

  def get_tab_class(a, b) when a == b do
    "tab tab-bordered tab-active"
  end

  def get_tab_class(a, b) do
    "tab tab-bordered"
  end

end