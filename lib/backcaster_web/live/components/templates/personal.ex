defmodule Personal do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string
  prop show_edit, :boolean, default: true

  def render(assigns) do
    ~F"""
    <div class="card compact shadow mt-2 summary-content">
      <div class="card-body">
        <p class="big-template-text">I want to <InlineEdit
            backcast={@backcast}
            category="Personal Goal"
            parent_pid={@parent_pid}
            show_edit={@show_edit}
            id={"#{@id}_1"}
          /> so that I can <InlineEdit
            backcast={@backcast}
            category="Personal Why"
            parent_pid={@parent_pid}
            show_edit={@show_edit}
            id={"#{@id}_2"}
          /> with <InlineEdit
            backcast={@backcast}
            category="Personal Community"
            parent_pid={@parent_pid}
            show_edit={@show_edit}
            id={"#{@id}_3"}
          /></p>
      </div>
    </div>
    """
    end

end