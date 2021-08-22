defmodule Summary do
  use Surface.LiveComponent

  prop board, :map
  prop backcast, :map


  def count_milestones(milestones, cond) do
    milestones
    |> Enum.filter(fn {k, m} -> m["active"] == cond end)
    |> length()
  end

  def get_card_or_tbc(nil) do
    "TBC"
  end

  def get_card_or_tbc(card) do
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
    <div class="grid grid-cols-2 gap-2 p-6 lg:bg-base-200 rounded-box my-2">
        <h1 class="title">Due date : {@board.goal_date}</h1>
        <h1 class="title">Time remaining : {Date.diff(@board.goal_date, Date.utc_today())} days</h1>
        <h1 class="title">{count_milestones(@backcast["milestones"], true)} Active milestones</h1>
        <h1 class="title">{count_milestones(@backcast["milestones"], false)} Complete milestones</h1>
        </div>
        <div class="card shadow-lglg:p-10 xl:grid-cols-2 lg:bg-base-200 rounded-box p-8 text-xl">
          <p><span class="emphasis">{get_card_or_tbc(@backcast["cards"]["Project Name"])}</span> is {a_or_an(@backcast["cards"]["Project Type"]["content"])} <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["Project Type"])}</span> for <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["Intended Audience"])}</span>.</p>
          <br>
          <p>Solving the problem of <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["The Problem it solves"])}</span>, leading to <span class="emphasis">{get_card_or_tbc(@backcast["cards"]["Benefits"])}</span>.</p>

          <div class="card shadow-2xl lg:card-side bg-secondary text-secondary-content my-6">
            <div class="card-body">
            <q>{get_card_or_tbc(@backcast["cards"]["Inspirational Quote"])}</q> - Anon
            </div>
          </div>

          <div class="example-ad">
            Ad <span style="padding:0 5px">·</span> <a href="#">https://{get_card_or_tbc(@backcast["cards"]["Project Name"])}.com</a><br>
            <a href="#" class="example-link">{get_card_or_tbc(@backcast["cards"]["Project Name"])} | {get_card_or_tbc(@backcast["cards"]["The Problem it solves"])} solved!</a><br>
            {get_card_or_tbc(@backcast["cards"]["Call to Action"])}
          </div>

        </div>
      """
    end

end