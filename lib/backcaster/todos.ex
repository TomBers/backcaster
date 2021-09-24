defmodule Backcaster.Todos do

  def sample do
    board = %BurnListBoard{
      created_at: Date.utc_today(),
      items: [
        BurnListItem.make_item("TodoItem 1"),
      ]
    }

    history = %BurnListHistory{
      current: board,
      past: [board]
    }
    BurnListHistory.add_item(history,  BurnListItem.make_item("Second Item"))
    |> BurnListHistory.add_item(BurnListItem.make_item("Third Item"))
  end

end