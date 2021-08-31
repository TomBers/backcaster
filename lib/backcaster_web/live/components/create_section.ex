defmodule CreateSection do
  use Surface.LiveComponent

  alias Backcaster.SampleData

  prop click, :event, required: true
  data edit, :boolean, default: false

  def render(assigns) do
    ~F"""
    <div class="card shadow-lg md:card-side">
      <div class="card-body">
        {#if @edit}
          <div>
            <div class="justify-end card-actions">
              <button class="btn btn-secondary btn-square" :on-click="edit">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 stroke-current">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            <br>
            <div class="btn-group" :on-click="edit">
              {#for item <- SampleData.possible_sections()}
                <button class="btn btn-outline btn-lg create-section-btn" :on-click={@click} phx-value-type={item}>{item}</button>
              {/for}
            </div>
          </div>
        {#else}
          <button class="btn btn-outline" id="add-section-btn" :on-click="edit"><svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg></button>
        {/if}
      </div>
    </div>
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

end