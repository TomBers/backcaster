defmodule BackcasterWeb.FsmLive do
  use Surface.LiveView

  @impl true
  def mount(%{"fsm" => fsm_name_str}, _session, socket) do
#    TODO put in Server startup
    Generate.build_all()

    module_name = String.to_existing_atom(fsm_name_str)
    initial_state = %{state: "A"}

    opts = module_name.get_state_options(initial_state)
#    IO.inspect(opts)

    socket =
      socket
      |> assign(:fsm_state, initial_state)
      |> assign(:state_options, opts)
      |> assign(:module_name, module_name)
    {:ok, socket}
  end

  def handle_event("update_state", %{"opt" => opt}, socket) do
    module_name = socket.assigns.module_name

    {:ok, new_state} =
      socket.assigns.fsm_state
    |> module_name.get_next_state_from_selected_options(opt)
    |> module_name.transition()

    socket =
      socket
      |> assign(:fsm_state, new_state)
      |> assign(:state_options, module_name.get_state_options(new_state))

    {:noreply, socket}
  end

end