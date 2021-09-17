defmodule Summary do
  use Surface.LiveComponent

  prop board, :map
  prop backcast, :map
  prop parent_pid, :string

  def render(assigns) do
    ~F"""
      {#case @backcast["template"]}
        {#match "startup"}
          <Startup board={@board} backcast={@backcast} parent_pid={self()} id="startup" />
      {/case}
    """
    end

end