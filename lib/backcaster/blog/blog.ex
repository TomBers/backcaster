defmodule Blog do
  def tags do
    ["Unstuck", "Coding"]
  end

  def articles do
    [
      %{href: "tooling.html", label: "tooling.html", has_graph: false, tags: ["Coding"]},
      %{href: "getting_started.html", label: "getting_started.html", has_graph: true, tags: ["Unstuck"]}
    ]
  end
end