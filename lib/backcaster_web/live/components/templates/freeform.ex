defmodule Freeform do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

  def render(assigns) do
    ~F"""
    <div class="card compact shadow mt-2">
      <div class="card-body">
        <p><InlineEdit backcast={@backcast} category="Freeform" parent_pid={@parent_pid} use_text_area id={Enum.random(1..4000)} /></p>
      </div>
    </div>
    """
    end

end