defmodule CreateMilestone do
  use Surface.LiveComponent

  prop title, :string
  prop date, :string

  data vals, :map, default: %{"name" => "", "email" => ""}

  data edit, :boolean, default: false
  prop submit, :event, required: true

  def render(assigns) do
    ~F"""
    <div class="card card-side compact text-center">
      <div class="card-body">
        <div class="card-title">Add Milestone</div>
        <button class="btn btn-outline" id="add-milestone" :on-click="edit">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>
        </button>
        <div :if={@edit}>
          <MilestoneForm title="" date={Date.utc_today()} submit={@submit} id={@id} edit="edit" button_text="Add" show_template />
        </div>
      </div>
    </div>
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

end