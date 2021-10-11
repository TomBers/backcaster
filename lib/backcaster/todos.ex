defmodule Backcaster.Todos do

  def sample do
    category = "A List"
    board = %BurnListBoard{
      created_at: Date.utc_today(),
      items: [
        BurnListItem.make_item("TodoItem 1", category),
        BurnListItem.make_item("Second Item", category),
        BurnListItem.make_item("Third Item", category)
      ]
    }

    %BurnListHistory{
      categories: [category, "BOB"],
      current: board,
      past: [board]
    }

  end

end