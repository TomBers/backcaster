defmodule FiveW do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string

  def render(assigns) do
    ~F"""
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-4 mt-2">
      <div class="card shadow compact">
        <div class="card-title m-2">Why? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Why" parent_pid={@parent_pid} id="why" />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">What? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="What" parent_pid={@parent_pid} id="what" />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">Who? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Who" parent_pid={@parent_pid} id="who" />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">When? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="When" parent_pid={@parent_pid} id="when" />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">Where? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Where" parent_pid={@parent_pid} id="where" />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">(How? :)</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="How" parent_pid={@parent_pid} id="how" />
        </div>
      </div>
    </div>
    """
    end

end