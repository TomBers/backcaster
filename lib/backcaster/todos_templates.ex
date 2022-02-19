defmodule Backcaster.TodosTemplates do

  def milestone_templates() do
    ["Pick a template", "Validation", "Marketing"]
  end

#  Ideas: Customer feedback, product validation, website checklist, product launch, setup analytics, security checklist
# Marketing checklist, Twitter engagement, background reading, blogging, marketing
  def gen_template(opt) do
    case opt do
      "Validation" -> gen_items(["Validate", "Ask 1 person", "Ask bob"])
      "Marketing" -> gen_items(["Marketing", "Twitter"])
      _ -> gen_items([])
    end
  end

  defp gen_items(items) do
    todo = BurnListCategory.new_category("TODO")
    items
    |> Enum.map(fn item -> BurnListItem.make_item(item, todo) end)
    |> base_template(todo)
  end

  defp base_template(items, todo) do
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