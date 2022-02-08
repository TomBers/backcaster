defmodule BackcasterWeb.PageLive do
  use BackcasterWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    theme = Map.get(params, "theme", "cupcake")
    {:ok, socket |> assign(:theme, theme)}
  end

end
