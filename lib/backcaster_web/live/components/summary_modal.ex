defmodule SummaryModal do
  use Surface.LiveComponent

  prop template, :string
  prop backcast, :map

  def mount(socket) do
    {:ok, socket}
  end

  end