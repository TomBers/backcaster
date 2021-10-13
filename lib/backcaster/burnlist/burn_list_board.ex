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

  def reorder_item(board, category_uid, old_visual_index, new_visual_index) do
    old_index = get_actual_index(board.items, category_uid, old_visual_index)
    new_index = get_actual_index(board.items, category_uid, new_visual_index)
    item = Enum.at(board.items, old_index)
    new_items =
      board.items
      |> List.delete_at(old_index)
      |> List.insert_at(new_index, BurnListItem.make_item(item.text, item.category))

    %BurnListBoard{
      created_at: Date.utc_today(),
      items: new_items,
      categories: board.categories
    }
  end

#  From the front end we get a visual index (which order the item was drawn, but that does not correspond to the index in the board so we need to look it up
  def get_actual_index(items, category_uid, visual_index) do
    {item, index} =
      items
    |> Enum.with_index
    |> Enum.filter(fn {x, index} -> x.category.uuid == category_uid and x.state == :active end)
    |> Enum.reverse
    |> Enum.at(visual_index)

     index
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

  def remove_category(board, uuid) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: board.items |> Enum.filter(fn x -> x.uuid != uuid end),
      categories: board.categories |> Enum.filter(fn x -> x.uuid != uuid end)
    }
  end

end