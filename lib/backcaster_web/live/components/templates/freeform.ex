defmodule Freeform do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string
  prop show_edit, :boolean, default: true

  def render(assigns) do
    ~F"""
    <div class="card compact shadow mt-2 summary-content">
      <div class="card-body big-template-text">
        <p><InlineEdit
            backcast={@backcast}
            category="Freeform"
            parent_pid={@parent_pid}
            use_text_area
            show_edit={@show_edit}
            id={Enum.random(1..4000)}
          /></p>
      </div>
    </div>
    """
    end

end