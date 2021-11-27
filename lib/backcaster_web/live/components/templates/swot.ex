defmodule Swot do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

#  TODO - make the boxes have a title (use the card comp??)
  def render(assigns) do
    ~F"""
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-4 mt-2">
      <div class="card compact shadow">
        <div class="card-title m-2">Strengths:</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Strengths" parent_pid={@parent_pid} use_text_area id="strengths" />
        </div>
      </div>
      <div class="card compact shadow">
        <div class="card-title m-2">Weaknesses:</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Weaknesses" parent_pid={@parent_pid} use_text_area id="weaknesses" />
        </div>
      </div>
      <div class="card compact shadow">
        <div class="card-title m-2">Opportunities:</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Opportunities" parent_pid={@parent_pid} use_text_area id="opportunities" />
        </div>
      </div>
      <div class="card compact shadow">
        <div class="card-title m-2">Threats:</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Threats" parent_pid={@parent_pid} use_text_area id="threats" />
        </div>
      </div>
    </div>
    """
    end

end