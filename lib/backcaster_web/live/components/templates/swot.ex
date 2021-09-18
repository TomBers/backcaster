defmodule Swot do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

  def render(assigns) do
    ~F"""
    <p>Strengths: <InlineEdit backcast={@backcast} category="Strengths" parent_pid={@parent_pid} id="strengths" /></p>
    <br>
    <p>Weaknesses: <InlineEdit backcast={@backcast} category="Weaknesses" parent_pid={@parent_pid} id="weaknesses" /></p>
    <br>
    <p>Opportunities: <InlineEdit backcast={@backcast} category="Opportunities" parent_pid={@parent_pid} id="opportunities" /></p>
    <br>
    <p>Threats: <InlineEdit backcast={@backcast} category="Threats" parent_pid={@parent_pid} id="threats" /></p>
    """
    end

end