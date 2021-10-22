defmodule BurnListItem do
  @derive {Jason.Encoder, except: []}
  defstruct [text: "", state: :active, uuid: nil, created_at: nil, updated_at: nil, category: "default"]

  def make_item(text, %BurnListCategory{} = category) do
    created_at = Date.utc_today()
    %BurnListItem{text: text, uuid: UUID.uuid4(), category: category, created_at: created_at, updated_at: created_at }
  end

  def make_item(text, %BurnListItem{category: category, created_at: created_at}) do
    %BurnListItem{text: text, uuid: UUID.uuid4(), category: category, created_at: created_at, updated_at: Date.utc_today() }
  end

  def make_item(text, created_at, %BurnListCategory{} = category) do
    %BurnListItem{text: text, uuid: UUID.uuid4(), category: category, created_at: created_at, updated_at: Date.utc_today() }
  end

end