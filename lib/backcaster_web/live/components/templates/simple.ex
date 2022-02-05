defmodule Simple do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string
  prop show_edit, :boolean, default: true

  def render(assigns) do
    ~F"""
    <div class="card compact shadow mt-2">
      <div class="card-body">
        <p class="big-template-text">What? : <InlineEdit backcast={@backcast} category="What" parent_pid={@parent_pid} show_edit={@show_edit} id={Enum.random(1..4000)} /></p>
        <br>
        <p class="big-template-text">Why? : <InlineEdit backcast={@backcast} category="Why" parent_pid={@parent_pid} show_edit={@show_edit} id={Enum.random(1..4000)} /></p>
        <br>
        <p class="big-template-text">How? : <InlineEdit backcast={@backcast} category="How" parent_pid={@parent_pid} show_edit={@show_edit} id={Enum.random(1..4000)} /></p>
      </div>
    </div>
    """
    end

end