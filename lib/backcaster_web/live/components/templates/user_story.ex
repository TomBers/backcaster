defmodule UserStory do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string
  prop show_edit, :boolean, default: true

  def render(assigns) do
    ~F"""
    <div class="card compact shadow mt-2 summary-content">
      <div class="card-body big-template-text">
        <p>As a ..</p>
        <InlineEdit
          backcast={@backcast}
          category="user_story_who"
          parent_pid={@parent_pid}
          show_edit={@show_edit}
          id={Enum.random(1..4000)}
        />
        <p>I want ..</p>
        <p>
          <InlineEdit
            backcast={@backcast}
            category="user_story_want"
            parent_pid={@parent_pid}
            use_text_area
            show_edit={@show_edit}
            id={Enum.random(1..4000)}
          /></p>
        <p>So that ..</p>
        <InlineEdit
          backcast={@backcast}
          category="user_story_that"
          parent_pid={@parent_pid}
          use_text_area
          show_edit={@show_edit}
          id={Enum.random(1..4000)}
        />
      </div>
    </div>
    """
    end

end