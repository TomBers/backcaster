defmodule Board do
  use Surface.LiveComponent

  prop cards, :map
  prop submit, :event, required: true
  prop add_field, :event, required: true
  prop delete_field, :event, required: true

  data edit, :boolean, default: false

  def render(assigns) do
    ~F"""
      <div class="overflow-x-auto">
    <table class="table table-fixed w-full">
    <thead>
      <tr>
        <th class="w-1/4">Goals</th>
        <th class="w-1/2"></th>
        <th></th>
        <th><button class="btn btn-sm btn-secondary edit-milestone" :on-click="edit">{#if @edit}Done {#else}Edit{/if}</button></th>
      </tr>
    </thead>
    <tbody>
     {#for {key, card} <- Enum.sort(@cards, fn {_k1, v1}, {_k2, v2} -> v1["order"] <= v2["order"] end)}
        <tr class="">
          <td style="white-space: revert;">{card["title"]}</td>
          <td style="white-space: revert;"><Section section={card} submit={@submit} edit={@edit} id={key} /></td>
          <td></td>
          <td>
              <button class="btn btn-circle btn-xs" :on-click={@delete_field} phx-value-label={key}>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-4 h-4 stroke-current">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
              </button>
          </td>
        </tr>
        {/for}
        <tr>
          <td colspan="4">
            <CreateSection click={@add_field} id="create" />
          </td>
        </tr>
    </tbody>
    </table>
    </div>
    """
    end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end
end