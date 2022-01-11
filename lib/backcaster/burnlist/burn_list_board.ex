defmodule BurnListBoard do
  @derive {Jason.Encoder, except: []}
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
      items: board.items ++ items,
      categories: board.categories
    }
  end

  def add_items(board, items) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: [board.items | items],
      categories: board.categories
    }
  end

  def edit_item(board, old_item, new_item) do
    index = Enum.find_index(board.items, fn x -> x.uuid == old_item.uuid end)

    %BurnListBoard{
      created_at: Date.utc_today(),
      items: List.replace_at(board.items, index, new_item),
      categories: board.categories
    }
  end



  def reordered_board(board, new_index, new_item, old_item_uid) do
    new_items =
      board.items
      |> List.insert_at(new_index, new_item)
      |> Enum.filter(fn items -> items.uuid != old_item_uid end)

    %BurnListBoard{
      created_at: Date.utc_today(),
      items: new_items,
      categories: board.categories
    }
  end


  def reorder_item(board, to_category_uid, old_visual_index, new_visual_index, item_uid)  do
    new_index = get_actual_index(board.items, to_category_uid, old_visual_index,  new_visual_index)
    category = board.categories |> Enum.find(fn x -> x.uuid == to_category_uid end)
    old_item = board.items |> Enum.find(fn itm -> itm.uuid == item_uid end)
    new_item = BurnListItem.make_item(old_item.text, old_item.created_at, category)
    reordered_board(board, new_index, new_item, item_uid)
  end

#  From the front end we get a visual index (which order the item was drawn)
#  This that does not correspond to the index in the board so reproduce the steps needed,
#  filter by category and visible and reverse
  def get_actual_index(items, category_uid, old_visual_index, visual_index) do
    visible_items =
      items
    |> Enum.with_index
    |> Enum.filter(fn {x, index} -> x.category.uuid == category_uid and x.state == :active end)

      case Enum.at(visible_items, visual_index) do
        {_item, index} -> work_out_index(index, old_visual_index, visual_index)
        nil -> calc_no_match_index(visible_items)
    end
  end

  def calc_no_match_index(items) do
    case List.last(items) do
      {_item, indx} -> indx + 1
      nil -> length(items)
    end

  end

  def work_out_index(item_index, old_visual_index, 0) do
    0
  end

  def work_out_index(item_index, old_visual_index, visual_index) do
      if old_visual_index >= visual_index do
          item_index
        else
          item_index + 1
      end
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
