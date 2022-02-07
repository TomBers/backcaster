defmodule Swot do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string
  prop show_edit, :boolean, default: true

#  TODO - make the boxes have a title (use the card comp??)
  def render(assigns) do
    ~F"""
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-4 mt-2">
      <div class="card compact shadow summary-content">
        <div class="card-title m-2">Strengths:</div>
        <div class="card-body">
          <InlineEdit
            backcast={@backcast}
            category="Strengths"
            parent_pid={@parent_pid}
            use_text_area
            show_edit={@show_edit}
            id={"#{@id}_1"}
          />
        </div>
      </div>
      <div class="card compact shadow">
        <div class="card-title m-2">Weaknesses:</div>
        <div class="card-body">
          <InlineEdit
            backcast={@backcast}
            category="Weaknesses"
            parent_pid={@parent_pid}
            use_text_area
            show_edit={@show_edit}
            id={"#{@id}_2"}
          />
        </div>
      </div>
      <div class="card compact shadow">
        <div class="card-title m-2">Opportunities:</div>
        <div class="card-body">
          <InlineEdit
            backcast={@backcast}
            category="Opportunities"
            parent_pid={@parent_pid}
            use_text_area
            show_edit={@show_edit}
            id={"#{@id}_3"}
          />
        </div>
      </div>
      <div class="card compact shadow">
        <div class="card-title m-2">Threats:</div>
        <div class="card-body">
          <InlineEdit
            backcast={@backcast}
            category="Threats"
            parent_pid={@parent_pid}
            use_text_area
            show_edit={@show_edit}
            id={"#{@id}_4"}
          />
        </div>
      </div>
    </div>
    """
    end

end