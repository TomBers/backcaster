defmodule BackcasterWeb.MyBoardsLive do
  use Surface.LiveView
  alias Surface.Components.Form

  def mount(params, _session, socket) do
    theme = Map.get(params, "theme", "lofi")
    {:ok, socket |> assign(:theme, theme)}
  end

end