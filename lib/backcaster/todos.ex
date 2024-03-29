defmodule Backcaster.Todos do

  def simple do
    board = %BurnListBoard{
      created_at: Date.utc_today(),
      items: [
      ],
      categories: [BurnListCategory.new_category("TODO"), BurnListCategory.new_category("Doing"), BurnListCategory.new_category("Done")]
    }

    %BurnListHistory{
      current: board,
      past: [board]
    }
  end

  # TEST DATA
#  def sample do
#    category = BurnListCategory.new_category("A list")
#    category_2 = BurnListCategory.new_category("Second list")
#    board = %BurnListBoard{
#      created_at: Date.utc_today(),
#      items: [
##        BurnListItem.make_item("Item 3", category),
##        BurnListItem.make_item("Item 2", category),
#        BurnListItem.make_item("Item 1", category),
#        BurnListItem.make_item("AAAA", category_2),
#        BurnListItem.make_item("BBBB", category_2),
#        BurnListItem.make_item("CCCC", category_2)
#      ],
#      categories: [category, category_2],
#    }
#
#    %BurnListHistory{
#      current: board,
#      past: [board]
#    }
#  end

  def hydrate(history, is_new?) when is_new? == true do
    history
  end

  def hydrate(json, is_new?) do
    %BurnListHistory{
      current: hydrate_board(json["current"]),
      past: json["past"] |> Enum.map(fn x -> hydrate_board(x) end)
    }
  end

  def hydrate_board(board_json) do
    %BurnListBoard{
      created_at: Date.from_iso8601!(board_json["created_at"]),
      items: board_json["items"] |> Enum.map(fn item -> hydrate_item(item) end),
      categories: board_json["categories"] |> Enum.map(fn cat -> hydrate_cat(cat) end),
    }
  end

  def hydrate_item(item) do
    %BurnListItem{
      created_at: Date.from_iso8601!(item["created_at"]),
      updated_at: Date.from_iso8601!(item["updated_at"]),
      text: item["text"],
      uuid: item["uuid"],
      state: String.to_atom(item["state"]),
      labels: item["labels"] || [],
      category: %BurnListCategory{ text: item["category"]["text"], uuid: item["category"]["uuid"], created_at: Date.from_iso8601!(item["category"]["created_at"])}
    }
  end

  def hydrate_cat(cat) do
    %BurnListCategory{
      text: cat["text"], uuid: cat["uuid"], created_at: Date.from_iso8601!(cat["created_at"])
    }
  end

end