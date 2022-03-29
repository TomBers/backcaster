defmodule BackcasterWeb.FsmLive do
  use Surface.LiveView

  @impl true
  def mount(%{"fsm" => fsm_name_str}, _session, socket) do
    #    TODO put in Server startup
    Generate.build_all()

    fsm = String.to_existing_atom(fsm_name_str)
    initial_state = %{state: fsm.first_state()}

    socket =
      socket
      |> assign(:fsm_state, initial_state)
      |> assign(:state_options, fsm.get_state_options(initial_state))
      |> assign(:fsm, fsm)
      |> assign(:finished, false)
    {:ok, socket}
  end

  def handle_event("update_state", %{"opt" => opt}, socket) do
    fsm = socket.assigns.fsm

    #    TODO handle errors in state transition
    {:ok, new_state} =
      socket.assigns.fsm_state
      |> fsm.get_next_state_from_selected_option(opt)
      |> fsm.transition()

    socket =
      socket
      |> assign(:fsm_state, new_state)
      |> assign(:state_options, fsm.get_state_options(new_state))
      |> assign(:finished, new_state.state == fsm.last_state)

    {:noreply, socket}
  end

end