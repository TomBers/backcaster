defmodule GanttChart do
  use Surface.LiveComponent

  prop board, :map

  def render(assigns) do
    ~F"""
    <label for="my-modal-2" class="btn btn-primary modal-button">timeline</label>
    <input type="checkbox" id="my-modal-2" class="modal-toggle">
    <div class="modal">
      <div class="modal-box" style="min-width: 100%; background-color: lightgrey">
        <div class="mermaid">
          gantt
            title Timeline
            dateFormat  YYYY-MM-DD
            axisFormat  %d-%b
            section Overall
            GOAL :a, {Date.utc_today()}, {Date.diff(@board.goal_date, Date.utc_today())}d
            section Milestones
            . :a1, {Date.utc_today()}, 0d
            {#for {_id, milestone} <- @board.content["milestones"]}
              {#if milestone["active"]}
                {milestone["title"]} :milestone, {milestone["date"]}, 0d
              {#else}
                {milestone["title"]} :done, {Date.utc_today()}, {find_milestone_diff(milestone["date"])}d
              {/if}

            {/for}
        </div>
        <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js" />
        <script>mermaid.initialize({ startOnLoad: true });</script>
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

end