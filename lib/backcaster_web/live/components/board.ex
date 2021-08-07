defmodule Board do
  use Surface.LiveComponent

  prop cards, :map
  prop submit, :event, required: true

  def render(assigns) do
    ~F"""
      <div class="overflow-x-auto">
    <table class="table w-full">
    <thead>
      <tr>
        <th>Category</th>
        <th></th>
        <th></th>
      </tr>
    </thead>
    <tbody>
     {#for {key, card} <- @cards}
        <tr class="">
          <td>{card["title"]}</td>
          <td>{card["content"]}</td>
          <td><Section title={key} value={card["content"]} submit={@submit} id={key} /></td>
        </tr>
        {/for}
    </tbody>
    </table>
    </div>
    """
    end
end