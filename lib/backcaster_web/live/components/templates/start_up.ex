defmodule Startup do
  use Surface.LiveComponent

  prop backcast, :map
  prop parent_pid, :string
  prop show_edit, :boolean, default: true


  def get_card_or_tbc(cards, key) do
    card = Map.get(cards, key, %{"content" => ""})
    card["content"]
  end

  def a_or_an(nil) do "a" end

  def a_or_an(type) do
    if String.starts_with?(type, ["a", "A"]) do
      "an"
      else
      "a"
    end
  end

  def render(assigns) do
    ~F"""
    <div class="card compact shadow mt-2">
      <div class="card-body">
        <p class="big-template-text"><InlineEdit
            backcast={@backcast}
            category="Project Name"
            parent_pid={@parent_pid}
            show_edit={@show_edit}
            id={Enum.random(1..4000)}
          /> is {a_or_an(get_card_or_tbc(@backcast["cards"], "Project Type"))} <InlineEdit
            backcast={@backcast}
            category="Project Type"
            parent_pid={@parent_pid}
            show_edit={@show_edit}
            id={Enum.random(1..4000)}
          /> for <InlineEdit
            backcast={@backcast}
            category="Intended Audience"
            parent_pid={@parent_pid}
            show_edit={@show_edit}
            id={Enum.random(1..4000)}
          />.</p>
        <br>

        <p class="big-template-text">Solving the problem of <InlineEdit
            backcast={@backcast}
            category="The Problem it solves"
            parent_pid={@parent_pid}
            show_edit={@show_edit}
            id={Enum.random(1..4000)}
          />, leading to <InlineEdit
            backcast={@backcast}
            category="Benefits"
            parent_pid={@parent_pid}
            show_edit={@show_edit}
            id={Enum.random(1..4000)}
          />.</p>
        <br>
        {#if @show_edit}
          <a class="link" href="/blog/problem_statement.html" target="blank">What is a problem statement?</a>
        {/if}
        <div class="card shadow-xl lg:card-side my-6 bg-neutral text-neutral-content">
          <div class="card-body">
            <h1 class="card-title">What do you want people to say about your idea?</h1>
            <q><InlineEdit
                backcast={@backcast}
                category="Inspirational Quote"
                parent_pid={@parent_pid}
                show_edit={@show_edit}
                id={Enum.random(1..4000)}
              /></q>
          </div>
        </div>
      </div>
    </div>
    """
    end

end