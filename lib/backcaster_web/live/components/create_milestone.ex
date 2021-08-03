defmodule CreateMilestone do
  use Surface.LiveComponent

  prop title, :string
  prop date, :string

  data vals, :map, default: %{"name" => "", "email" => ""}

  data edit, :boolean, default: false
  prop submit, :event, required: true

  def render(assigns) do
    ~F"""
    <div class="card shadow-lg md:card-side bg-secondary">
      <div class="card-body">
        <button class="btn-sm is-info add-milestone" :on-click="edit">
              Add
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 ml-2 stroke-current">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
          </svg>
        </button>
        <div :if={@edit}>
          <MilestoneForm title="" date={Date.utc_today()} submit={@submit} id={@id} edit="edit" button_text="Add" />
        </div>
      </div>
    </div>
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

end