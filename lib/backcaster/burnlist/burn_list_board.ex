defmodule BurnListBoard do
  defstruct [created_at: nil, items: []]

  def create_board(items) do
    %BurnListBoard{
      created_at: Date.utc_today(),
      items: items
    }
  end

end