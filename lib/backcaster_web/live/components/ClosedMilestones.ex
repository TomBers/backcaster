defmodule ClosedMilestones do
  use Surface.LiveComponent

  prop milestones, :any
  prop change_active, :event, required: true
  data is_open, :boolean, default: true

  def render(assigns) do
    ~F"""
    <h1 class="ml-8" :on-click="is_open">Closed ({length(@milestones)})</h1>
    {#if @is_open}
      <div class="grid grid-cols-1 gap-4 lg:p-4 xl:grid-cols-2 lg:bg-base-200 rounded-box">
        {#for {id, milestone} <- @milestones}
          <div class="card-body">
            <div class="justify-end card-actions">
              <h2 class="card-title faded break-all">{milestone["title"]}</h2>
              <div data-tip="Reopen" class="tooltip tooltip-bottom">
                <input type="checkbox" :on-click={@change_active} phx-value-id={id} class="toggle toggle-secondary">
              </div>
            </div>

            <p class="faded">Done: {date_completed(milestone["completed"])}</p>
          </div>
        {/for}
      </div>
    {/if}
    """
  end

  def handle_event("is_open", _, socket) do
    {:noreply, update(socket, :is_open, fn _ -> !socket.assigns.is_open end)}
  end

  def date_completed(complete) when is_bitstring(complete) do
    {:ok, datetime, 0} = DateTime.from_iso8601(complete)
    date_completed(datetime)
  end

  def date_completed(complete) do
    DateTime.to_date(complete)
  end


end