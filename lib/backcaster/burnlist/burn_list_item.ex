defmodule BurnListItem do
  @enforce_keys [:text]
  defstruct [text: "", state: :active, uuid: nil, created_at: nil, updated_at: nil, category: "default"]

#  def make_item(text) do
#    %BurnListItem{text: text, uuid: UUID.uuid4(), created_at: Date.add(Date.utc_today(), Enum.random([-1,-2,-3,-4]))}
#  end

  def make_item(text, %BurnListCategory{} = category) do
    created_at = Date.add(Date.utc_today(), Enum.random([-1,-2,-3,-4, -8, -9]))
    %BurnListItem{text: text, uuid: UUID.uuid4(), category: category, created_at: created_at, updated_at: created_at }
  end

  def make_item(text, %BurnListItem{category: category, created_at: created_at}) do
    %BurnListItem{text: text, uuid: UUID.uuid4(), category: category, created_at: created_at, updated_at: Date.utc_today() }
  end

end