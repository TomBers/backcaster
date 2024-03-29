defmodule BackcasterWeb.BurnListLive do
  use Surface.LiveView

  alias Backcaster.SampleData
  alias Backcaster.Backcast

  alias Surface.Components.LivePatch
  alias Surface.Components.Form
  alias Surface.Components.Form.{RangeInput}

  @save_time 1_000

  def mount(%{"id" => id} = params, _session, socket) do

    if connected?(socket) do
      Backcast.subscribe()
    end

    theme = Map.get(params, "theme", "dark")
    mode = Map.get(params, "mode", "narrow")
    title = Map.get(params, "title", "")
    parent_board = Map.get(params, "board", nil)

    {is_new?, board} =
      Backcast.get_or_create_board!(id, Backcaster.Todos.simple())

    history = board.content |> Backcaster.Todos.hydrate(is_new?)

    socket =
      socket
      |> assign(:history, history)
      |> assign(:board, board)
      |> assign(:theme, theme)
      |> assign(:mode, mode)
      |> assign(:title, title)
      |> assign(:parent_board, parent_board)
      |> assign(:add_count, 0)

    {:ok, socket}
  end

  @impl true
  def handle_event("set_current", %{"current" => [current]}, socket) do
    index = length(socket.assigns.history.past) - String.to_integer(current)
    socket =
      socket
      |> assign(:history, BurnListHistory.set_current(socket.assigns.history, index))
    {:noreply, socket}
  end

  def handle_event("add_category", _params, socket) do
    socket =
      socket
      |> assign(:history, BurnListHistory.add_category(socket.assigns.history))

      Task.start(fn -> SampleData.persist_board(socket.assigns.history, socket.assigns.board, socket.root_pid) end)

    {:noreply, socket}
  end

  def handle_event("remove_category", %{"value" => uuid}, socket) do
    socket =
      socket
      |> assign(:history, BurnListHistory.remove_category(socket.assigns.history, uuid))

      Task.start(fn -> SampleData.persist_board(socket.assigns.history, socket.assigns.board, socket.root_pid) end)

    {:noreply, socket}
  end

  def handle_event("add_item", %{"add_item" => %{"content" => text, "category" => category_uuid}}, socket) do
    category = Enum.find(socket.assigns.history.current.categories, fn x -> x.uuid == category_uuid end)
    items =
      Regex.split( ~r/\r|\n|\r\n/, String.trim(text))
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.map(fn txt -> BurnListItem.make_item(txt, category) end)

    socket =
      socket
      |> assign(:history, BurnListHistory.add_items(socket.assigns.history, items))
      |> assign(:add_count, socket.assigns.add_count + 1)

      Task.start(fn -> SampleData.persist_board(socket.assigns.history, socket.assigns.board, socket.root_pid) end)

    {:noreply, socket}
  end

  def handle_event("delete_item", %{"value" => uuid}, socket) do
    history = socket.assigns.history
    old_item =
      Enum.find(history.current.items, fn x -> x.uuid == uuid end)
    socket =
      socket
      |> assign(:history, BurnListHistory.delete_item(history, old_item))

      Task.start(fn -> SampleData.persist_board(socket.assigns.history, socket.assigns.board, socket.root_pid) end)

    {:noreply, socket}
  end

  def handle_event("reorder", %{"to_category_id" => to_category_id, "old_index" => old_index, "new_index" => new_index, "item_uid" => item_uid} = params, socket) do
    socket =
      socket
      |> assign(:history, BurnListHistory.reorder_item(socket.assigns.history, to_category_id, old_index, new_index, item_uid))

      Task.start(fn -> SampleData.persist_board(socket.assigns.history, socket.assigns.board, socket.root_pid) end)

    {:noreply, socket}
  end

  def handle_info(%{"edit_item" => %{"content" => text, "uuid" => uuid}}, socket) do
    history = socket.assigns.history
    old_item =
      Enum.find(history.current.items, fn x -> x.uuid == uuid end)
    socket =
      socket
      |> assign(:history, BurnListHistory.edit_item(history, old_item, BurnListItem.update_text(text, old_item)))

      Task.start(fn -> SampleData.persist_board(socket.assigns.history, socket.assigns.board, socket.root_pid) end)

    {:noreply, socket}
  end

  def handle_info(%{"edit_category" => %{"content" => content, "uuid" => uuid}}, socket) do
    socket =
      socket
      |> assign(:history, BurnListHistory.edit_category(socket.assigns.history, content, uuid))

      Task.start(fn -> SampleData.persist_board(socket.assigns.history, socket.assigns.board, socket.root_pid) end)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_edit, {board_id, sending_pid}}, socket) do
    if board_id == socket.assigns.board.name and sending_pid != self() do
      {is_new?, board} =
        Backcast.get_or_create_board!(board_id, Backcaster.Todos.simple())

      history = board.content |> Backcaster.Todos.hydrate(is_new?)
      socket =
        socket
        |> assign(:history, history)
        |> assign(:board, board)
      {:noreply, socket}
      else
      {:noreply, socket}
    end
  end

  def filter_items(items, category) do
    items
    |> Enum.filter(fn item -> item.state == :active and item.category.uuid == category.uuid end)
  end

  def calc_closed(items, category) do
    items
    |> Enum.filter(fn item -> item.state != :active and item.category.uuid == category.uuid end)
    |> length()
  end

end
