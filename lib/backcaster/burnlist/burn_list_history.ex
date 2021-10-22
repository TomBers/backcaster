defmodule BurnListHistory do
  @derive {Jason.Encoder, except: []}
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
    add_new_board(history, BurnListBoard.add_category(get_most_recent_board(history)))
  end

  def edit_category(history, text, uuid) do
    add_new_board(history, BurnListBoard.edit_category(get_most_recent_board(history), text, uuid))
  end

  def remove_category(history, uuid) do
    add_new_board(history, BurnListBoard.remove_category(get_most_recent_board(history), uuid))
  end

  def add_items(history, items) do
    add_new_board(history, BurnListBoard.add_items(get_most_recent_board(history), items))
  end

  def edit_item(history, old_item, new_item) do
    add_new_board(history, BurnListBoard.edit_item(get_most_recent_board(history), old_item, new_item))
  end

  def reorder_item(history, to_category_id, old_index, new_index, item_uid) do
    add_new_board(history, BurnListBoard.reorder_item(get_most_recent_board(history), to_category_id, old_index, new_index, item_uid))
  end

  def delete_item(history, item) do
    add_new_board(history, BurnListBoard.edit_item(get_most_recent_board(history), item, %{item | state: :deleted}))
  end

  def set_current(history, index) do
    %BurnListHistory{
      current: Enum.at(history.past, index),
      past: history.past
    }
  end
  
  def get_most_recent_board(history) do
    List.first(history.past)
  end

end