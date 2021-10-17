defmodule Backcaster.BurnListTest do
  use Backcaster.DataCase

  describe "test the burnlist" do
    test "create item" do
      item = BurnListItem.make_item("Test")
      assert item.text == "Test"
      assert item.state == :active
    end

    test "create board" do
      board = BurnListBoard.create_board([BurnListItem.make_item("Test")])
      assert board.created_at == Date.utc_today()
      assert length(board.items) == 1
    end

    test "create history" do
      board = BurnListBoard.create_board([BurnListItem.make_item("Test")])
      history = BurnListHistory.add_new_board(nil, board)

      assert history.current == board
      assert history.past |> List.first == board
    end

    test "add item" do
      board = BurnListBoard.create_board([BurnListItem.make_item("Test")])
      history = BurnListHistory.add_new_board(nil, board)

      new_history = BurnListHistory.add_items(history, BurnListItem.make_item("Added Item"))

      assert new_history.current.items |> length == 2
      assert new_history.past |> length == 2

    end

    test "add multiple items" do
      board = BurnListBoard.create_board([BurnListItem.make_item("Test")])
      history = BurnListHistory.add_new_board(nil, board)

      new_history = BurnListHistory.add_items(history, [BurnListItem.make_item("Added Item"), BurnListItem.make_item("Second Added Item")])


      assert new_history.current.items |> length == 3
      assert new_history.past |> length == 2

    end

    test "edit item" do
      item = BurnListItem.make_item("Test")
      board = BurnListBoard.create_board([item])
      history = BurnListHistory.add_new_board(nil, board)

      new_item = BurnListItem.make_item("Edit Item")
      new_history = BurnListHistory.edit_item(history, item, new_item)

      assert new_history.current.items |> length == 1
      assert new_history.current.items |> List.first == new_item
      assert new_history.past |> length == 2

    end

    test "delete item" do
      item = BurnListItem.make_item("Test")
      board = BurnListBoard.create_board([item])
      history = BurnListHistory.add_new_board(nil, board)

      new_history = BurnListHistory.delete_item(history, item)
      assert new_history.current.items |> List.first |> Map.get(:state) == :deleted
    end

    test "set previous item to current" do
      item = BurnListItem.make_item("Test")
      board = BurnListBoard.create_board([item])
      history = BurnListHistory.add_new_board(nil, board)

      assert history.current == board

      new_history = BurnListHistory.add_items(history, BurnListItem.make_item("Added Item"))
      assert new_history.current != board

      assert BurnListHistory.set_current(new_history, 1).current == board

    end

  end

end