defmodule GanttChart do
  use Surface.LiveComponent

  prop goal_date, :date
  prop milestones, :map

  def render(assigns) do
    ~F"""
    <label for="my-modal-2" class="btn btn-primary modal-button">open timeline</label>
    <input type="checkbox" id="my-modal-2" class="modal-toggle">
    <div class="modal">
      <div class="modal-box" style="min-width: 90%">
        <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js" />
        <script>mermaid.initialize({ startOnLoad: true });</script>
        <div class="mermaid">
          gantt
            title Project timeline
            dateFormat  YYYY-MM-DD
            section Overall
            GOAL :a, {Date.utc_today()}, {Date.diff(@goal_date, Date.utc_today())}d
            section Milestones
            . :a1, {Date.utc_today()}, 0d
            {#for {_id, milestone} <- @milestones}
              {milestone["title"]} {get_milestone_label(milestone)}, {Date.utc_today()}, {find_milestone_diff(milestone["date"])}d
            {/for}
        </div>
        <div class="modal-action">
          <label for="my-modal-2" class="btn">Close</label>
        </div>
      </div>
    </div>
    """
  end

  def find_milestone_diff(date_str) do
    date_str
    |> Date.from_iso8601!()
    |> Date.diff(Date.utc_today())
  end

  def get_milestone_label(milestone) do
    if milestone["active"] do
      ":milestone"
      else
      ":done"
    end
  end


end