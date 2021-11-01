defmodule Backcaster.Backcast do
  @moduledoc """
  The Backcast context.
  """

  import Ecto.Query, warn: false
  alias Backcaster.Repo

  alias Backcaster.Backcast.Board

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards do
    Repo.all(Board)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id), do: Repo.get!(Board, id)

  def get_board_by_name!(id), do: Repo.get_by!(Board, name: id)


  def get_or_create_board!(name, goal_date, content \\ %{}) do
    case Repo.get_by(Board, name: name) do
      nil -> {true, create_board_quietly(%{name: name, content: content, goal_date: goal_date})}
      board -> {false, board}
    end
  end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  def create_board_quietly(attrs) do
    {:ok, board} = create_board(attrs)
    board
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Backcaster.PubSub, "posts")
  end

  def broadcast_new_todo(board_id) do
    IO.inspect("Broadcasting!!")
    Phoenix.PubSub.broadcast(Backcaster.PubSub, "posts", {:new_burnlist_item, board_id}) |> IO.inspect
  end

#  defp broadcast({:ok, post}, event) do
#    Phoenix.PubSub.broadcast(Backcaster.PubSub, "posts", {event, post})
#    {:ok, post}
#  end

end
