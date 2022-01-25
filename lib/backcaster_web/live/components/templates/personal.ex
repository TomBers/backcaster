defmodule Personal do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

  def render(assigns) do
    ~F"""
    <div class="card compact shadow mt-2">
      <div class="card-body">
        <p class="big-template-text">I want to <InlineEdit backcast={@backcast} category="Personal Goal" parent_pid={@parent_pid} id={Enum.random(1..4000)} /> so that I can <InlineEdit backcast={@backcast} category="Personal Why" parent_pid={@parent_pid} id={Enum.random(1..4000)} /> with <InlineEdit backcast={@backcast} category="Personal Community" parent_pid={@parent_pid} id={Enum.random(1..4000)} />.</p>
      </div>
    </div>
    """
    end

end