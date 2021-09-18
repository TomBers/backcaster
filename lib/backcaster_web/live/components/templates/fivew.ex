defmodule FiveW do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

  def render(assigns) do
    ~F"""
    <p>Why? : <InlineEdit backcast={@backcast} category="Why" parent_pid={@parent_pid} id="why" /></p>
    <br>
    <p>What? : <InlineEdit backcast={@backcast} category="What" parent_pid={@parent_pid} id="what" /></p>
    <br>
    <p>Who? : <InlineEdit backcast={@backcast} category="Who" parent_pid={@parent_pid} id="who" /></p>
    <br>
    <p>When? : <InlineEdit backcast={@backcast} category="When" parent_pid={@parent_pid} id="when" /></p>
    <br>
    <p>Where? : <InlineEdit backcast={@backcast} category="Where" parent_pid={@parent_pid} id="where" /></p>
    <br>
    <br>
    <p>(How? : <InlineEdit backcast={@backcast} category="How" parent_pid={@parent_pid} id="how" />)</p>
    """
    end

end