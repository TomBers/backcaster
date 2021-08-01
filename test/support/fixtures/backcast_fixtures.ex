defmodule Backcaster.BackcastFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backcaster.Backcast` context.
  """

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{
        content: %{},
        name: "some name"
      })
      |> Backcaster.Backcast.create_board()

    board
  end
end
