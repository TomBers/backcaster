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
            <input type="checkbox" checked="checked" :on-click={@change_active} phx-value-id={@milestone_id} class="toggle toggle-secondary">
      </div>
        <h2 class="card-title text-primary-content">{@title}</h2>
        <p class="text-primary-content">{@date} ({calc_date_diff(@date)} days to go)</p>

        <div class="justify-end card-actions">
          <button class="btn-sm btn-secondary edit-milestone" :on-click="edit">
                Edit
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 ml-2 stroke-current">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
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
      <div class="card-body">
      <div class="justify-end card-actions">
            <input type="checkbox" :on-click={@change_active} phx-value-id={@milestone_id} class="toggle toggle-secondary">
      </div>
        <h2 class="card-title faded">{@title}</h2>
        <p class="faded">Done: {@completed}</p>
      </div>
      </div>
    {/if}
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

  def calc_date_diff(date) when is_bitstring(date) do
    Date.diff(Date.from_iso8601!(date), Date.utc_today())
  end

  def calc_date_diff(date) do
    Date.diff(date, Date.utc_today())
  end

end