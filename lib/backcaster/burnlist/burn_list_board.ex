defmodule BurnListBoard do
  defstruct [created_at: nil, items: []]

  def create_board(items) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: items
    }
  end

  def add_items(board, items) when is_list(items) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: items ++ board.items
    }
  end

  def add_items(board, items) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: [items | board.items]
    }
  end

  def edit_item(board, old_item, new_item) do
    index = Enum.find_index(board.items, fn x -> x == old_item end)
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: List.replace_at(board.items, index, new_item)
    }
  end

end