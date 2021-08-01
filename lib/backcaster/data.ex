defmodule Backcaster.SampleData do
  def sample(_id) do
    %{
      "Title" => "A sample title",
      "Quote" => "Quote",
      "CustomerComments" => "Best thing ever, changed my life",
      "Another" => "Another Category"
    }
  end

  def possible_sections do
    ["A section", "B section", "C section"]
  end
end