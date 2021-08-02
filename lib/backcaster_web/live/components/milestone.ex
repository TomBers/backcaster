defmodule Milestone do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, DateInput, Label, Field}

  prop title, :string
  prop date, :date

  data vals, :map, default: %{"name" => "", "email" => ""}

  data edit, :boolean, default: false
  prop submit, :event, required: true

  def render(assigns) do
    ~F"""
    <div class="card shadow-lg md:card-side bg-secondary">
      <div class="card-body">
        <h2 class="card-title">{@title}</h2>
        <p>{@date} ({Date.diff(Date.from_iso8601!(@date), Date.utc_today())} days to go)</p>
        <div class="justify-end card-actions">
          <button class="btn-sm btn-secondary" :on-click="edit">
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
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

end