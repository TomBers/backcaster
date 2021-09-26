defmodule BurnListItem do
  @enforce_keys [:text]
  defstruct [text: "", state: :active, uuid: nil, created_at: nil]

  def make_item(text) do
    %BurnListItem{text: text, uuid: UUID.uuid4(), created_at: Date.add(Date.utc_today(), Enum.random([-1,-2,-3,-4]))}
  end


end