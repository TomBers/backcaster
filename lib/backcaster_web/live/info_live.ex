defmodule BackcasterWeb.InfoLive do
  use Surface.LiveView

  def mount(%{"board" => board}, _session, socket) do
    socket =
      socket
      |> assign(:theme, "lofi")
      |> assign(:board_id, board)
    {:ok, socket}
  end

  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:theme, "lofi")
      |> assign(:board_id, nil)
    {:ok, socket}
  end

end