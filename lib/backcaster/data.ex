defmodule Backcaster.SampleData do
  def sample(_id) do
    %{
      "Title" => "A sample title",
      "Quote" => "Quote",
      "CustomerComments" => "Best thing ever, changed my life",
      "Another" => "Another Category"
    }
  end
end