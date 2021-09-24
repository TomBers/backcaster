defmodule Backcaster.Todos do

  def sample do
    board = %BurnListBoard{
      created_at: Date.utc_today(),
      items: [
        %BurnListItem{text: "TodoItem 1"},
        %BurnListItem{text: "Item 2"}
      ]
    }

    %BurnListHistory{
      current: board,
      past: [board]
    }
  end

end