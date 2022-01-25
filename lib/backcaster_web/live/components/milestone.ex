defmodule Milestone do
  use Surface.LiveComponent
  alias Surface.Components.LivePatch

  prop title, :string
  prop date, :date
  prop completed, :date
  prop milestone_id, :string
  prop uuid, :string
  prop theme, :string
  prop mode, :string
  prop board_name, :string
  prop checked, :boolean

  data vals, :map, default: %{"name" => "", "email" => ""}

  data edit, :boolean, default: false
  prop submit, :event, required: true
  prop change_active, :event, required: true

  def render(assigns) do
    ~F"""
    <div class="card shadow-lg compact side bg-base-100">
      <div class="card-body">
        <div class="justify-end card-actions tight-bottom">
          <div data-tip="Complete" class="tooltip tooltip-bottom">
            <input
              type="checkbox"
              checked="checked"
              :on-click={@change_active}
              phx-value-id={@milestone_id}
              class="toggle toggle-primary"
            />
          </div>
        </div>
        <div class="flex-1">
          <h2 class="card-title word-break">{@title} <div data-tip="Edit milestone" class="tooltip tooltip-bottom">
              <button class="btn-sm edit-milestone" :on-click="edit">
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
          </h2>
          <p class="text-base-content text-opacity-40">({calc_date_diff(@date)} days to go)</p>
          <div :if={@edit}>
            <MilestoneForm title={@title} date={@date} submit={@submit} id={@id} button_text="Update" edit="edit" />
          </div>
        </div>
      </div>
      <LivePatch to={"/burnlist/#{@uuid}?theme=#{@theme}&title=#{@title}&board=#{@board_name}&mode=#{@mode}"}>
        <button class="btn btn-block btn-secondary btn-sm make-square">
          Todo
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            class="inline-block w-4 h-4 ml-2 stroke-current"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>
      </LivePatch>
    </div>
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