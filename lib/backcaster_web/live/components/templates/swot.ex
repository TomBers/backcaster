defmodule Swot do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

#  TODO - make the boxes have a title (use the card comp??)
  def render(assigns) do
    ~F"""
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-6">
      <div class="card">
          <div class="card-title">Strengths:</div>
          <div class="card-body">
            <InlineEdit backcast={@backcast} category="Strengths" parent_pid={@parent_pid} use_text_area={true} id="strengths" />
          </div>
      </div>
      <div class="card">
          <div class="card-title">Weaknesses:</div>
          <div class="card-body">
            <InlineEdit backcast={@backcast} category="Weaknesses" parent_pid={@parent_pid} use_text_area={true} id="weaknesses" />
          </div>
      </div>
      <div class="card">
          <div class="card-title">Opportunities:</div>
          <div class="card-body">
            <InlineEdit backcast={@backcast} category="Opportunities" parent_pid={@parent_pid} use_text_area={true} id="opportunities" />
          </div>
      </div>
      <div class="card">
          <div class="card-title">Threats:</div>
          <div class="card-body">
            <InlineEdit backcast={@backcast} category="Threats" parent_pid={@parent_pid} use_text_area={true} id="threats" />
          </div>
      </div>
    </div>
    """
    end

end