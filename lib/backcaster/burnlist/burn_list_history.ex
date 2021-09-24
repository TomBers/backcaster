defmodule BurnListHistory do
  defstruct [current: nil, past: []]

  def add_new_board(nil, board) do
    %BurnListHistory{
      current: board,
      past: [board]
    }
  end

  def add_new_board(history, board) do
    %BurnListHistory{
      current: board,
      past: [board | history.past]
    }
  end

  def add_item(history, item) do
    add_new_board(history, BurnListBoard.add_item(history.current, item))
  end

  def edit_item(history, old_item, new_item) do
    add_new_board(history, BurnListBoard.edit_item(history.current, old_item, new_item))
  end

  def delete_item(history, item) do
    add_new_board(history, BurnListBoard.edit_item(history.current, item, %{item | state: :deleted}))
  end

  def set_current(history, index) do
    %BurnListHistory{
      current: Enum.at(history.past, index),
      past: history.past
    }
  end

end