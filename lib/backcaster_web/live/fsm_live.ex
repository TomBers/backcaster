defmodule BackcasterWeb.FsmLive do
  use Surface.LiveView

  @impl true
  def mount(%{"fsm" => fsm_name_str} = params, _session, socket) do
  
    theme = Map.get(params, "theme", "dark")

    fsm = String.to_existing_atom(fsm_name_str)
    initial_state = fsm.first_state()

    socket =
      socket
      |> assign(:fsm_state, initial_state)
      |> assign(:state_options, fsm.get_state_options(initial_state))
      |> assign(:fsm, fsm)
      |> assign(:finished, false)
      |> assign(:flow_chart, fsm.flow_chart())
      |> assign(:hist, [])
      |> assign(:theme, theme)
      
    {:ok, socket}
  end

  def get_theme_url(theme) do
    "?theme=#{theme}"
  end

  @impl true
  def handle_event("update_state", %{"opt" => opt}, socket) do
    fsm = socket.assigns.fsm

    hist = %{opt: opt, state: socket.assigns.fsm_state.state}

    #    TODO handle errors in state transition
    {:ok, new_state} =
      socket.assigns.fsm_state
      |> fsm.get_next_state_from_selected_option(opt)
      |> fsm.transition()

    socket =
      socket
      |> assign(:fsm_state, new_state)
      |> assign(:state_options, fsm.get_state_options(new_state))
      |> assign(:finished, fsm.is_finished?(new_state))
      |> assign(:hist, socket.assigns.hist ++ [hist])

    {:noreply, socket}
  end

end