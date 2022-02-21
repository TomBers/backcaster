defmodule BackcasterWeb.BackcastLive do
  use Surface.LiveView

  alias BackcasterWeb.Router.Helpers, as: Routes

  alias Backcaster.SampleData
  alias Backcaster.Backcast

  def mount(%{"id" => id} = params, _session, socket) do
    if connected?(socket) do
      Backcast.subscribe()
    end

    theme = Map.get(params, "theme", "dark")

    mode = Map.get(params, "mode", "narrow")

    {_created, board} = Backcast.get_or_create_board!(id, SampleData.simple())

#    IO.inspect(board)

    socket =
      socket
      |> assign(:backcast, board.content)
      |> assign(:board, board)
      |> assign(:theme, theme)
      |> assign(:show_image_processing, false)
      |> assign(:active_tab, "description")
      |> assign(:work_mode, mode)
      |> assign(:rename_error, nil)

    {:ok, socket}
  end
  
#  Handles updating problem statement, the handle_info is because we want to close the field after editing, so a message is sent
  def handle_info(%{"vals" => fields}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.update_fields(socket.assigns.backcast, fields))
      Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board, socket.root_pid) end)
      
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

    Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board, socket.root_pid) end)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_edit, {board_id, sending_pid}}, socket) do
    if board_id == socket.assigns.board.name and sending_pid != self() do
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

  def handle_info(%{"name_change" => %{"new_board_name" => new_name}}, socket) do
    case SampleData.update_board_name(socket.assigns.board, new_name) do
      {:ok, _updated} -> {:noreply, push_redirect(socket, to: Routes.backcast_path(socket, :index, new_name), replace: true)}
      {:error, error} -> {:noreply, socket |> assign(:rename_error, "Couldn't rename board - name already taken")}
    end

  end


  def handle_event("update_milestone", %{"vals" => %{"date" => date, "title" => title, "id" => id}}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.update_milestone(socket.assigns.backcast, id, title, date))

      Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board, socket.root_pid) end)
    {:noreply, socket}
  end

  #  Use milestone template
  def handle_event("create_milestone", %{"vals" => %{"date" => date, "title" => "", "id" => id, "template" => template} = params}, socket) do

    {backcast, milestone_id} = SampleData.add_milestone(socket.assigns.backcast, id, template, date)
    socket =
      socket
      |> assign(:backcast, backcast)

    Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board, socket.root_pid); Backcast.get_or_create_board!(milestone_id, Backcaster.TodosTemplates.gen_template(template)) end)
    {:noreply, socket}
  end

#  Use milestone title
  def handle_event("create_milestone", %{"vals" => %{"date" => date, "title" => title, "id" => id, "template" => template} = params}, socket) do
    {backcast, _mid} = SampleData.add_milestone(socket.assigns.backcast, id, title, date)
    socket =
      socket
      |> assign(:backcast, backcast)

      Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board, socket.root_pid) end)
    {:noreply, socket}
  end

  def handle_event("delete_image", %{"id" => img_id}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.delete_image(socket.assigns.backcast, img_id))

    Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board, socket.root_pid) end)

    {:noreply, socket}
  end

  def handle_event("change_template", %{"theme" => %{"template" => template}}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.set_theme(socket.assigns.backcast, template))

      Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board, socket.root_pid) end)

    {:noreply, socket}
  end



  def handle_event("change_active", %{"id" => id}, socket) do
    socket =
      socket
    |> assign(:backcast, SampleData.toggle_milestone(socket.assigns.backcast, id))

    Task.start(fn -> SampleData.persist_board(socket.assigns.backcast, socket.assigns.board, socket.root_pid) end)

    {:noreply, socket}
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, socket |> assign(:active_tab, tab)}
  end

  def handle_event("change_mode", _params, socket) do
    new_mode =
      case socket.assigns.work_mode do
        "dashboard" -> "narrow"
        "narrow" -> "dashboard"
        _ -> "narrow"
        end
    {:noreply, socket |> assign(:work_mode, new_mode)}
  end

  @impl true
  def handle_info(%{"web_path" => web_path, "file_path" => file_path, name: "store_image"}, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.add_image(socket.assigns.backcast, web_path, file_path))

    SampleData.persist_board(socket.assigns.backcast, socket.assigns.board, socket.root_pid)

    {:noreply, assign(socket, :show_image_processing, true)}
  end

  def sort_milestones(milestones) do
    Enum.sort(milestones, fn {_k1, v1}, {_k2, v2} -> v1["date"] <= v2["date"] end)
  end

  def active_milestones(backcast) do
    Map.get(backcast, "milestones", []) |> filter_milestones(true)
  end

  def closed_milestones(backcast) do
    Map.get(backcast, "milestones", []) |> filter_milestones(false)
  end

  def filter_milestones(milestones, is_active) do
    milestones
    |> Enum.filter(fn {k, m} -> m["active"] == is_active end)
  end

  def get_tab_class(a, b) when a == b do
    "tab tab-bordered tab-active"
  end

  def get_tab_class(a, b) do
    "tab tab-bordered"
  end

  def get_col_class(work_mode) do
    case work_mode do
      "dashboard" -> "grid grid-cols-1 md:grid-cols-2 gap-8"
      _ -> "grid grid-cols-1 gap-8"
      end
  end

  def get_container_class(work_mode) do
    case work_mode do
      "dashboard" -> "container mx-auto"
      _ -> "container mx-auto lg:px-40 xl:px-64"
    end
  end

  def get_theme_url(theme, work_mode) do
    "?theme=#{theme}&mode=#{work_mode}"
  end

end