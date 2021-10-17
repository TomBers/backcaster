defmodule BurnListItem do
  @derive {Jason.Encoder, except: []}
  defstruct [text: "", state: :active, uuid: nil, created_at: nil, category: "default"]

#  def make_item(text) do
#    %BurnListItem{text: text, uuid: UUID.uuid4(), created_at: Date.add(Date.utc_today(), Enum.random([-1,-2,-3,-4]))}
#  end

  def make_item(text, category) do
    %BurnListItem{text: text, uuid: UUID.uuid4(), category: category, created_at: Date.add(Date.utc_today(), Enum.random([-1,-2,-3,-4]))}
  end

end