defmodule ClosedMilestones do
  use Surface.LiveComponent

  prop milestones, :any
  prop change_active, :event, required: true

  def render(assigns) do
    ~F"""
    <div class="collapse collapse-arrow mt-6">
      <input type="checkbox">
      <div class="collapse-title text-xl font-medium">
        Closed milestones ({length(@milestones)})
      </div>
      <div class="collapse-content">
        <div class="grid grid-cols-1">
          {#for {id, milestone} <- @milestones}
            <div class="grid justify-items-start grid-cols-2">
              <div data-tip={date_completed(milestone["completed"]) |> complete_string()} class="tooltip tooltip-right">
                <h2 class="break-word text-left">{milestone["title"]}</h2>
              </div>
              <div data-tip="Reopen" class="tooltip tooltip-left justify-self-end">
                <input type="checkbox" :on-click={@change_active} phx-value-id={id} class="toggle toggle-secondary justify-self-end">
              </div>
            </div>
          {/for}
        </div>
      </div>
    </div>
    """
  end

  def complete_string(date) do
    "Completed at: #{date}"
  end

  def date_completed(complete) when is_bitstring(complete) do
    {:ok, datetime, 0} = DateTime.from_iso8601(complete)
    date_completed(datetime)
  end

  def date_completed(complete) do
    DateTime.to_date(complete)
  end


end