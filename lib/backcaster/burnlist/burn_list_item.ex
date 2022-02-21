defmodule BurnListItem do
  @derive {Jason.Encoder, except: []}
  defstruct [text: "", state: :active, uuid: nil, created_at: nil, updated_at: nil, category: "default", labels: []]

  def make_item(text, %BurnListCategory{} = category, labels \\ []) do
    created_at = Date.utc_today()
    %BurnListItem{text: text, uuid: UUID.uuid4(), category: category, created_at: created_at, updated_at: created_at, labels: labels }
  end

#  def make_item(text, created_at, %BurnListCategory{} = category, labels \\ []) do
#    %BurnListItem{text: text, uuid: UUID.uuid4(), category: category, created_at: created_at, updated_at: Date.utc_today(), labels: labels }
#  end

  def update_item(text, bli) do
    bli
    |> Map.put(:text, text)
    |> Map.put(:uuid, UUID.uuid4())
    |> Map.put(:updated_at, Date.utc_today())
  end

end