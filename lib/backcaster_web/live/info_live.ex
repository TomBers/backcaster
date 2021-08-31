defmodule BackcasterWeb.InfoLive do
  use Surface.LiveView

  def mount(%{"board" => board}, _session, socket) do
    {:ok, assign(socket, :board_id, board)}
  end

  def mount(params, _session, socket) do
    {:ok, assign(socket, :board_id, nil)}
  end

end