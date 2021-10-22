defmodule Backcaster.Todos do

  def sample do
    category = BurnListCategory.new_category("A list")
    category_2 = BurnListCategory.new_category("Second list")
    board = %BurnListBoard{
      created_at: Date.utc_today(),
      items: [
        BurnListItem.make_item("Item 3", category),
        BurnListItem.make_item("Item 2", category),
        BurnListItem.make_item("Item 1", category),
        BurnListItem.make_item("AAAA", category_2),
        BurnListItem.make_item("BBBB", category_2),
        BurnListItem.make_item("CCCC", category_2)
      ],
      categories: [category, category_2],
    }

    %BurnListHistory{
      current: board,
      past: [board]
    }

  end

end