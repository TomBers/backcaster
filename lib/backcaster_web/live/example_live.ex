defmodule Hello do
  use Surface.Component

  def render(assigns) do
    ~F"""
    Hello, I'm a component!!!! Sweet as a Surface
    """
  end
end

# Using the component

defmodule BackcasterWeb.ExampleLive do
  use Surface.LiveView
end