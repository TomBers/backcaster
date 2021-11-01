defmodule BackcasterWeb.BurnListController do
  use BackcasterWeb, :controller

  alias Backcaster.Backcast
  alias Backcaster.SampleData

  def create_item(conn, %{"board_id" => board_id, "list_id" => list_id} = params) do
    board = Backcast.get_board_by_name!(board_id)
    history = board.content |> Backcaster.Todos.hydrate(false)
    category = Enum.find(history.current.categories, fn x -> x.uuid == list_id end)

    new_dat = BurnListHistory.add_items(history, [BurnListItem.make_item("example", category)])

    SampleData.persist_board(new_dat, board)


    json(conn, params)
  end


end