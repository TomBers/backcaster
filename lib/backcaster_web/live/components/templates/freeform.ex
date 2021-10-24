defmodule Freeform do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

  def render(assigns) do
    ~F"""
    <p><InlineEdit backcast={@backcast} category="Freeform" parent_pid={@parent_pid} use_text_area id="freeform" /></p>
    """
    end

end