defmodule BurnListItem do
  @enforce_keys [:text]
  defstruct [text: "", state: :active, uuid: nil]

  def make_item(text) do
    %BurnListItem{text: text, uuid: UUID.uuid4()}
  end


end