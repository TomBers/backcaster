defmodule Blog do
  def tags do
    ["Unstuck", "Coding"]
  end

  def articles do
    [
      %{href: "tooling.html", label: "tooling.html", tags: ["Coding"]},
      %{href: "getting_started.html", label: "getting_started.html", tags: ["Unstuck"]}

    ]
  end
end