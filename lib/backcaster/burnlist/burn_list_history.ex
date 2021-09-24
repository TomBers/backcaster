defmodule BurnListHistory do
  defstruct [current: nil, past: []]

  def add_new_board(nil, board) do
    %BurnListHistory{
      current: board,
      past: [board]
    }
  end

  def add_new_board(history, board) do
    %BurnListHistory{
      current: board,
      past: [board | history.past]
    }
  end

end