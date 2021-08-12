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

  def render(assigns) do
    ~F"""
    <div class="grid grid-cols-2 gap-6 lg:p-10 xl:grid-cols-2 lg:bg-base-200 rounded-box">
        <h1 class="title">Due date : {@board.goal_date}</h1>
        <h1 class="title">Time remaining: {Date.diff(@board.goal_date, Date.utc_today())} days</h1>
        <h1 class="title">{count_milestones(@backcast["milestones"], true)} Active milestones</h1>
        <h1 class="title">{count_milestones(@backcast["milestones"], false)} Complete milestones</h1>
        </div>
        <div class="card shadow-lglg:p-10 xl:grid-cols-2 lg:bg-base-200 rounded-box p-8">
          {get_card_or_tbc(@backcast["cards"]["Project Name"])} is a {get_card_or_tbc(@backcast["cards"]["Project Type"])} for {get_card_or_tbc(@backcast["cards"]["Intended Audience"])}.
          <br>
          It solves the problem of {get_card_or_tbc(@backcast["cards"]["The Problem it solves"])}, which allows {get_card_or_tbc(@backcast["cards"]["Benefits"])}.

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