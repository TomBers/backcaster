defmodule Backcaster.BackcastTest do
  use Backcaster.DataCase

  alias Backcaster.Backcast

  describe "boards" do
    alias Backcaster.Backcast.Board

    import Backcaster.BackcastFixtures

    @invalid_attrs %{content: nil, name: nil}

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Backcast.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Backcast.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      valid_attrs = %{content: %{}, name: "some name"}

      assert {:ok, %Board{} = board} = Backcast.create_board(valid_attrs)
      assert board.content == %{}
      assert board.name == "some name"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Backcast.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      update_attrs = %{content: %{}, name: "some updated name"}

      assert {:ok, %Board{} = board} = Backcast.update_board(board, update_attrs)
      assert board.content == %{}
      assert board.name == "some updated name"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Backcast.update_board(board, @invalid_attrs)
      assert board == Backcast.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Backcast.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Backcast.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Backcast.change_board(board)
    end
  end
end
