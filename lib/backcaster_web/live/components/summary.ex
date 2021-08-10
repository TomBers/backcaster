defmodule Summary do
  use Surface.LiveComponent

  prop board, :map
  prop backcast, :map


  def count_milestones(milestones, cond) do
    milestones
    |> Enum.filter(fn {k, m} -> m["active"] == cond end)
    |> length()
  end

  def render(assigns) do
    ~F"""
    <div class="grid grid-cols-1 gap-6 lg:p-10 xl:grid-cols-3 lg:bg-base-200 rounded-box">
      <h1 class="title">Board - {@board.name}</h1>
      <h1 class="title">Due date : {@board.goal_date}</h1>
      <h1 class="title">Time remaining: {Date.diff(@board.goal_date, Date.utc_today())} days</h1>
      <h1 class="title">{count_milestones(@backcast["milestones"], true)} Active milestones</h1>
      <h1 class="title">{count_milestones(@backcast["milestones"], false)} Complete milestones</h1>
      </div>
      """
    end

end