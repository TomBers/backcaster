defmodule Backcaster.BurnListApiTest do
  use Backcaster.DataCase

  alias BackcasterWeb.BurnListController

  describe "test the burnlist api creation" do
    test "empty request doesn't create item" do
      category = BurnListCategory.new_category()
      new_items = BurnListController.make_req_items(%{}, category)
      assert new_items == nil
    end

    test "create item" do
      category = BurnListCategory.new_category()
      new_items = BurnListController.make_req_items(%{"text" => "test item"}, category)
      assert new_items.text == "{\"text\":\"test item\"}"
    end

    test "create item with more complex data structure" do
      category = BurnListCategory.new_category()
      new_items = BurnListController.make_req_items(%{"text" => %{"name" => "complex name"}}, category)
      assert new_items.text == "{\"text\":{\"name\":\"complex name\"}}"
    end
  end
end