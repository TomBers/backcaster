defmodule BurnListItem do
  @enforce_keys [:text]
  defstruct [text: "", state: :active]

end