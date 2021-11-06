defmodule BackcasterWeb.PageLive do
  use BackcasterWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:theme, "lofi")}
  end

end
