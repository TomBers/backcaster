defmodule BurnListCategory do
  @derive {Jason.Encoder, except: []}
  defstruct [text: "", uuid: nil, created_at: nil]

  def new_category() do
    uuid = UUID.uuid4()
    today = Date.utc_today()
    %BurnListCategory{text: "#{today}_#{uuid}", uuid: uuid, created_at: today}
  end

  def new_category(category) do
    uuid = UUID.uuid4()
    today = Date.utc_today()
    %BurnListCategory{text: category, uuid: uuid, created_at: today}
  end

  def edit_category(category, name) do
    %BurnListCategory{text: name, uuid: category.uuid, created_at: Date.utc_today()}
  end

end