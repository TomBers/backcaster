defmodule GanttChart do
  use Surface.LiveComponent

  prop board, :map

  def render(assigns) do
    ~F"""
    <label for="my-modal-2" class="btn btn-primary modal-button" id="timelineBtn">timeline</label>
    <input type="checkbox" id="my-modal-2" class="modal-toggle">
    <div class="modal">
      <div
        class="modal-box"
        style="min-width: 100%; background-color: lightgrey"
        phx-hook="renderTimeLine"
        id="timeLineModal"
      >
        <div class="mermaid" id="timeline" data-board={timeline_str(@board)} />
        <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js" />
        <script>mermaid.initialize({ startOnLoad: false });</script>
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

  def timeline_str(board) do
    opening = 'gantt
            title Timeline
            dateFormat  YYYY-MM-DD
            axisFormat  %e-%b
            excludes weekends
            section Overall
            GOAL :a, #{Date.utc_today()}, #{Date.diff(board.goal_date, Date.utc_today())}d
            section Milestones
            . :a1, #{Date.utc_today()}, 0d\n'

    milestones =
      board.content["milestones"]
      |> Enum.reduce('', fn {_id, milestone}, acc -> acc ++ get_milestone_type(milestone, milestone["active"])  end)

    opening ++ milestones
  end

  def get_milestone_type(milestone, is_active) when is_active do
    '#{milestone["title"]} :milestone, #{milestone["date"]}, 0d\n'
  end

  def get_milestone_type(milestone, _is_active) do
    '#{milestone["title"]} :done, #{Date.utc_today()}, #{find_milestone_diff(milestone["date"])}d\n'
  end

end