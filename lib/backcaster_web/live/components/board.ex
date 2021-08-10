defmodule Board do
  use Surface.LiveComponent

  prop cards, :map
  prop submit, :event, required: true
  prop add_field, :event, required: true

  def render(assigns) do
    ~F"""
      <div class="overflow-x-auto">
    <table class="table w-full">
    <thead>
      <tr>
        <th>Goals</th>
        <th></th>
        <th></th>
      </tr>
    </thead>
    <tbody>
     {#for {key, card} <- Enum.sort(@cards, fn {_k1, v1}, {_k2, v2} -> v1["order"] <= v2["order"] end)}
        <tr class="">
          <td>{card["title"]}</td>
          <td>{card["content"]}</td>
          <td><Section title={key} value={card["content"]} submit={@submit} id={key} /></td>
        </tr>
        {/for}
        <tr>
          <td colspan="3">
            <CreateSection click={@add_field} id="create" />
          </td>
        </tr>
    </tbody>
    </table>
    </div>
    """
    end
end