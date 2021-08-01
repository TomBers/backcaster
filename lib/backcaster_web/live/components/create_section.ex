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
          <button class="button is-info" :on-click="edit">Close</button>
          <br>
            <div class="btn-group" :on-click="edit">
              {#for item <- SampleData.possible_sections}
                <button class="btn btn-outline btn-lg" :on-click={@click} phx-value-type={item}>{item}</button>
              {/for}
            </div>
          </div>
        {#else}
          <button class="button is-info" :on-click="edit">Add</button>
        {/if}
      </div>
    </div>
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

end