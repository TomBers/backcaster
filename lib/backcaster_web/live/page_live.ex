defmodule BackcasterWeb.PageLive do
  use BackcasterWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    theme = Map.get(params, "theme", "dark")
    {:ok, socket |> assign(:theme, theme)}
  end

  def get_theme_class(label, theme) when label == theme, do: "active"

  def get_theme_class(label, theme), do: ""

end
