defmodule Simple do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

  def render(assigns) do
    ~F"""
    <p>What? : <InlineEdit backcast={@backcast} category="What" parent_pid={@parent_pid} id="what" /></p>
    <br>
    <p>Why? : <InlineEdit backcast={@backcast} category="Why" parent_pid={@parent_pid} id="why" /></p>
    <br>
    <p>How? : <InlineEdit backcast={@backcast} category="How" parent_pid={@parent_pid} id="how" /></p>
    """
    end

end