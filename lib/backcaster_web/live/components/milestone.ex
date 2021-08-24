defmodule Milestone do
  use Surface.LiveComponent

  prop title, :string
  prop date, :date
  prop completed, :date
  prop milestone_id, :string
  prop checked, :boolean

  data vals, :map, default: %{"name" => "", "email" => ""}

  data edit, :boolean, default: false
  prop submit, :event, required: true
  prop change_active, :event, required: true

  def render(assigns) do
    ~F"""
    {#if @checked}
      <div class="card shadow-lg bg-secondary">
        <div class="card-body">
          <div class="justify-end card-actions">
            <input
              type="checkbox"
              checked="checked"
              :on-click={@change_active}
              phx-value-id={@milestone_id}
              class="toggle toggle-secondary"
            />
          </div>
          <h2 class="card-title text-primary-content">{@title}</h2>
          <p class="text-primary-content">{@date} ({calc_date_diff(@date)} days to go)</p>

          <div class="justify-end card-actions">
            <button class="btn-sm btn-secondary edit-milestone" :on-click="edit">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
                />
              </svg>
            </button>
          </div>
          <div :if={@edit}>
            <MilestoneForm title={@title} date={@date} submit={@submit} id={@id} button_text="Update" edit="edit" />
          </div>
        </div>
      </div>
    {#else}
      <div class="card shadow-lg md:card-side">
        {#if is_just_completed(@completed)}
          <div class="card-body milestone-closed">
            <div class="justify-end card-actions">
              <input type="checkbox" :on-click={@change_active} phx-value-id={@milestone_id} class="toggle toggle-secondary">
            </div>
            <h2 class="card-title faded">{@title}</h2>
            <p class="faded">Done: {date_completed(@completed)}</p>
          </div>
        {#else}
          <div class="card-body">
            <div class="justify-end card-actions">
              <input type="checkbox" :on-click={@change_active} phx-value-id={@milestone_id} class="toggle toggle-secondary">
            </div>
            <h2 class="card-title faded">{@title}</h2>
            <p class="faded">Done: {date_completed(@completed)}</p>
          </div>
        {/if}
      </div>
    {/if}
    """
  end

  def is_just_completed(complete) when is_bitstring(complete) do
    {:ok, datetime, 0} = DateTime.from_iso8601(complete)
    is_just_completed(datetime)
  end

  def is_just_completed(complete) do
    diff = DateTime.diff(DateTime.utc_now(), complete)
    diff < 2
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

  def date_completed(complete) when is_bitstring(complete) do
    {:ok, datetime, 0} = DateTime.from_iso8601(complete)
    date_completed(datetime)
  end

  def date_completed(complete) do
    DateTime.to_date(complete)
  end

  def calc_date_diff(date) when is_bitstring(date) do
    Date.diff(Date.from_iso8601!(date), Date.utc_today())
  end

  def calc_date_diff(date) do
    Date.diff(date, Date.utc_today())
  end

end