defmodule Backcaster.BurnListTest do
  use Backcaster.DataCase

  describe "test the burnlist" do
    test "create item" do
      item = %BurnListItem{text: "Test"}
      assert item.text == "Test"
      assert item.state == :active
    end

    test "create board" do
      board = BurnListBoard.create_board([%BurnListItem{text: "Test"}])
      assert board.created_at == Date.utc_today()
      assert length(board.items) == 1
    end

    test "create history" do
      board = BurnListBoard.create_board([%BurnListItem{text: "Test"}])
      history = BurnListHistory.add_new_board(nil, board)

      assert history.current == board
      assert history.past |> List.first == board
    end

    test "add item" do

    end

    test "edit item" do

    end

    test "reorder item" do

    end

    test "delete item" do

    end

  end

end