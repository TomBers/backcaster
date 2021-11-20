defmodule Swot do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

  def render(assigns) do
    ~F"""
    <div class="box-container">
      <div class="box">Strengths: <InlineEdit backcast={@backcast} category="Strengths" parent_pid={@parent_pid} use_text_area={true} id="strengths" /></div>
      <div class="box">Weaknesses: <InlineEdit backcast={@backcast} category="Weaknesses" parent_pid={@parent_pid} use_text_area={true} id="weaknesses" /></div>
      <div class="box">Opportunities: <InlineEdit backcast={@backcast} category="Opportunities" parent_pid={@parent_pid} use_text_area={true} id="opportunities" /></div>
      <div class="box">Threats: <InlineEdit backcast={@backcast} category="Threats" parent_pid={@parent_pid} use_text_area={true} id="threats" /></div>
    </div>
    """
    end

end