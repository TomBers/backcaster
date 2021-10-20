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

  def add_category(history) do
    add_new_board(history, BurnListBoard.add_category(history.current))
  end

  def edit_category(history, text, uuid) do
    add_new_board(history, BurnListBoard.edit_category(history.current, text, uuid))
  end

  def remove_category(history, uuid) do
    add_new_board(history, BurnListBoard.remove_category(history.current, uuid))
  end

  def add_items(history, items) do
    add_new_board(history, BurnListBoard.add_items(history.current, items))
  end

  def edit_item(history, old_item, new_item) do
    add_new_board(history, BurnListBoard.edit_item(history.current, old_item, new_item))
  end

  def reorder_item(history, to_category_id, old_index, new_index, item_uid) do
    add_new_board(history, BurnListBoard.reorder_item(history.current, to_category_id, old_index, new_index, item_uid))
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