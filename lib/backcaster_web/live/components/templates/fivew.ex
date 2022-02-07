defmodule FiveW do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string
  prop show_edit, :boolean, default: true

  def render(assigns) do
    ~F"""
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-4 mt-2">
      <div class="card shadow compact summary-content">
        <div class="card-title m-2">Why? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Why" parent_pid={@parent_pid} show_edit={@show_edit} id={"#{@id}_1"} />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">What? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="What" parent_pid={@parent_pid} show_edit={@show_edit} id={"#{@id}_2"} />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">Who? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Who" parent_pid={@parent_pid} show_edit={@show_edit} id={"#{@id}_3"} />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">When? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="When" parent_pid={@parent_pid} show_edit={@show_edit} id={"#{@id}_4"} />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">Where? :</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="Where" parent_pid={@parent_pid} show_edit={@show_edit} id={"#{@id}_5"} />
        </div>
      </div>
      <div class="card shadow compact">
        <div class="card-title m-2">(How? :)</div>
        <div class="card-body">
          <InlineEdit backcast={@backcast} category="How" parent_pid={@parent_pid} show_edit={@show_edit} id={"#{@id}_6"} />
        </div>
      </div>
    </div>
    """
    end

end