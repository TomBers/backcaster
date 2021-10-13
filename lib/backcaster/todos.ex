defmodule Backcaster.Todos do

  def sample do
    category = BurnListCategory.new_category("A list")
    board = %BurnListBoard{
      created_at: Date.utc_today(),
      items: [
        BurnListItem.make_item("Item 3", category),
        BurnListItem.make_item("Item 2", category),
        BurnListItem.make_item("Item 1", category)
      ],
      categories: [category],
    }

    %BurnListHistory{
      current: board,
      past: [board]
    }

  end

end