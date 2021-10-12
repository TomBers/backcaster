defmodule BurnListBoard do
  defstruct [created_at: nil, items: [], categories: []]

  def create_board(items) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: items
    }
  end

  def add_items(board, items) when is_list(items) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: items ++ board.items,
      categories: board.categories
    }
  end

  def add_items(board, items) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: [items | board.items],
      categories: board.categories
    }
  end

  def edit_item(board, old_item, new_item) do
    index = Enum.find_index(board.items, fn x -> x == old_item end)
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: List.replace_at(board.items, index, new_item),
      categories: board.categories
    }
  end

  def add_category(board) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: board.items,
      categories: board.categories ++ [BurnListCategory.new_category()],
    }
  end

  def edit_category(board, text, uuid) do
    index = Enum.find_index(board.categories, fn x -> x.uuid == uuid end)
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: board.items,
      categories: List.replace_at(board.categories, index, BurnListCategory.edit_category(Enum.at(board.categories, index), text))
    }
  end

end