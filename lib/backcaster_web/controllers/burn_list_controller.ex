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
    new_items = make_req_items(params, category)
    save_and_notify(board, history, new_items)
  end

  def save_and_notify(board, history, new_items) when length(new_items) > 0 do
    BurnListHistory.add_items(history, new_items)
    |> SampleData.persist_board(board)

    Backcaster.Backcast.broadcast_new_todo(board.name)
  end

  def save_and_notify(board, history, new_items) do
    nil
  end


  defp make_req_items(params, category) do
    params
    |> Enum.filter(fn {k, _v} -> k != "board_id" and k != "list_id" end)
    |> Enum.map(fn {k, v} -> BurnListItem.make_item(v, category) end)
  end


end