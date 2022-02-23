defmodule Backcaster.DataTest do
  use Backcaster.DataCase
  alias Backcaster.SampleData

  describe "the board data structure" do
    test "update a section" do
      test_val = "Test Content"
      new_data = SampleData.update_fields(SampleData.simple(), "ProductName", test_val)
      new_dict = new_data["cards"]["ProductName"]
      assert new_dict == %{"content" => "Test Content", "order" => 1, "title" => "Product Name"}
    end

    test "create a section" do
      data = SampleData.simple()
      test_val = "New Section"
      new_data = SampleData.add_field(data, test_val)
      new_dict = new_data["cards"][test_val]
      assert new_dict == %{"content" => "", "order" => length(Map.keys(data["cards"])) + 1, "title" => test_val}
    end

    test "create a milestone" do
      data = SampleData.simple()
      id = "2"
      title = "New Milestone"
      date = Date.utc_today()
      {new_data, milestone_id} = SampleData.add_milestone(data, id, title, date)

      assert length(Map.keys(new_data["milestones"])) == 2
      assert new_data["milestones"] == %{"1" => %{"date" => Date.add(Date.utc_today(), 4), "title" => "A milestone"}, "2" => %{"date" => date, "title" => "New Milestone"}}
    end

    test "update milestone" do
      data = SampleData.simple()
      id = "1"
      title = "Update Milestone"
      date = Date.utc_today()
      new_data = SampleData.update_milestone(data, id, title, date)
      assert length(Map.keys(new_data["milestones"])) == 1
      assert new_data["milestones"] == %{"1" => %{"date" => date, "title" => "Update Milestone"}}
    end

  end

end