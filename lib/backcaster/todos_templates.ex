defmodule Backcaster.TodosTemplates do

  def milestone_templates() do
    ["Validation", "Marketing"]
  end

  def gen_template(opt) do
    case opt do
      "Validation" -> val_template()
      "Marketing" -> gen_items(["Marketing", "Twitter"])
      _ -> gen_items([])
    end
  end

  def val_template do
    gen_items(["Validate", "Ask 1 person", "Ask bob"])
  end

  def gen_items(items) do
    todo = BurnListCategory.new_category("TODO")
    items
    |> Enum.map(fn item -> BurnListItem.make_item(item, todo) end)
    |> base_template(todo)
  end

  def base_template(items, todo) do
    doing = BurnListCategory.new_category("Doing")
    done = BurnListCategory.new_category("Done")
    board = %BurnListBoard{
      created_at: Date.utc_today(),
      items: items,
      categories: [todo, doing, done]
    }

    %BurnListHistory{
      current: board,
      past: []
    }
  end

end