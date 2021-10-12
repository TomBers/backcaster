defmodule Backcaster.Todos do

  def sample do
    category = BurnListCategory.new_category("A list")
    board = %BurnListBoard{
      created_at: Date.utc_today(),
      items: [
        BurnListItem.make_item("TodoItem 1", category),
        BurnListItem.make_item("Second Item", category),
        BurnListItem.make_item("Third Item", category)
      ],
      categories: [category],
    }

    %BurnListHistory{
      current: board,
      past: [board]
    }

  end

end