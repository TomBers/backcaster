defmodule Section do
  use Surface.LiveComponent

  prop title, :string
  prop value, :string

  prop click, :event, required: true

  def render(assigns) do
    ~F"""
    <div class="card shadow-lg md:card-side bg-secondary">
      <div class="card-body">
        <h2 class="card-title">{@title}</h2>
        <p>{@value}</p>
        <button class="button is-info" :on-click={@click} phx-value-title={@title}>+</button>
      </div>
    </div>
    """
  end

end

defmodule BackcasterWeb.BackcastLive do
  use Surface.LiveView

  alias Backcaster.SampleData

  def mount(%{"id" => id}, _session, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.sample(id))
    {:ok, socket}
  end

  def handle_event("update_field", %{"title" => title}, socket) do
    new_backcast = Map.replace(socket.assigns.backcast, title, "BOB")
    {:noreply, assign(socket, :backcast, new_backcast)}
  end


end