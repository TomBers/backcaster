defmodule ClosedMilestones do
  use Surface.LiveComponent

  prop milestones, :any
  prop change_active, :event, required: true
  data is_open, :boolean, default: true

  def render(assigns) do
    ~F"""
    <h1 class="card-title ml-8 mt-4" :on-click="is_open">Closed ({length(@milestones)})</h1>
    {#if @is_open}
      <div class="grid grid-cols-1 lg:p-4 lg:grid-cols-1  rounded-box">
        {#for {id, milestone} <- @milestones}
          <div class="grid justify-items-stretch grid-cols-3">
            <h2 class="card-title faded break-all">{milestone["title"]}</h2>
            <p class="faded">Done: {date_completed(milestone["completed"])}</p>
            <div data-tip="Reopen" class="tooltip tooltip-left justify-self-end">
                <input type="checkbox" :on-click={@change_active} phx-value-id={id} class="toggle toggle-secondary justify-self-end">
              </div>
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