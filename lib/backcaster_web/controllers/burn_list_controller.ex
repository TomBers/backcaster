defmodule BackcasterWeb.BurnListController do
  use BackcasterWeb, :controller

  alias Backcaster.Backcast
  alias Backcaster.SampleData

  def create_item(conn, %{"board_id" => board_id, "list_id" => list_id} = params) do
    board = Backcast.get_board_by_name!(board_id)
    history = board.content |> Backcaster.Todos.hydrate(false)
    category = Enum.find(history.current.categories, fn x -> x.uuid == list_id end)

    persist_items(board, params, history, category)

    json(conn, params)
  end

  defp persist_items(board, params, history, category) when is_nil(category) do
    nil
  end

  defp persist_items(board, params, history, category) do
    new_items = make_req_items(Map.drop(params, ["board_id", "list_id"]), category)
    save_and_notify(board, history, new_items)
  end

  def save_and_notify(board, history, new_item) when is_nil(new_item) do
    nil
  end

  def save_and_notify(board, history, new_item) do
    BurnListHistory.add_items(history, [new_item])
    |> SampleData.persist_board(board, self())

    Phoenix.PubSub.broadcast(Backcaster.PubSub, "new_edit", {:new_edit, board.name})
  end

  def make_req_items(params, category) when map_size(params) == 0 do
    nil
  end

  def make_req_items(params, category) do
    params
    |> Jason.encode!()
    |> BurnListItem.make_item(category)
  end


end