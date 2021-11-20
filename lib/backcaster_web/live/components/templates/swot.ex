defmodule Swot do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

#  TODO - make the boxes have a title (use the card comp??)
  def render(assigns) do
    ~F"""
    <div class="swot-box-container">
      <div class="swot-box"><div class="swot-title">Strengths:</div> <InlineEdit backcast={@backcast} category="Strengths" parent_pid={@parent_pid} use_text_area={true} id="strengths" /></div>
      <div class="swot-box"><div class="swot-title">Weaknesses:</div> <InlineEdit backcast={@backcast} category="Weaknesses" parent_pid={@parent_pid} use_text_area={true} id="weaknesses" /></div>
      <div class="swot-box"><div class="swot-title">Opportunities:</div> <InlineEdit backcast={@backcast} category="Opportunities" parent_pid={@parent_pid} use_text_area={true} id="opportunities" /></div>
      <div class="swot-box"><div class="swot-title">Threats:</div> <InlineEdit backcast={@backcast} category="Threats" parent_pid={@parent_pid} use_text_area={true} id="threats" /></div>
    </div>
    """
    end

end