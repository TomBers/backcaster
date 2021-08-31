defmodule Board do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, Label, Field}

  prop cards, :map
  prop submit, :event, required: true
  prop add_field, :event, required: true
  prop delete_field, :event, required: true

  data vals, :map, default: %{"type" => ""}

  data edit, :boolean, default: false

  def render(assigns) do
    ~F"""
    <div class="overflow-x-auto">
      <Form for={:vals} submit={@submit}>
        <table class="table table-fixed w-auto lg:w-full">
          <thead>
            <tr>
              <th class="w-1/4">Goals</th>
              <th class="w-1/2" />
              <th>
                {#if @edit}
                  <button class="btn btn-sm md:btn-sm btn-secondary edit-milestone float-right" :on-click={@submit} :on-click="edit"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4"
                      />
                    </svg></button>
                {#else}
                  <button class="btn btn-xs md:btn-sm btn-secondary edit-milestone float-right" :on-click="edit"><svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
                      />
                    </svg></button>
                {/if}
              </th>
            </tr>
          </thead>
          <tbody>
            {#for {key, card} <- Enum.sort(@cards, fn {_k1, v1}, {_k2, v2} -> v1["order"] <= v2["order"] end)}
              <tr class="">
                <td style="white-space: revert;">{card["title"]}</td>
                <td style="white-space: revert;">
                  {#if @edit}
                    <Field class="field" name={"#{card["title"]}__#{card["order"]}"}>
                      <div class="control">
                        <TextInput class="input input-secondary input-bordered" value={card["content"]} />
                      </div>
                    </Field>
                  {#else}
                    {card["content"]}
                  {/if}
                </td>
                <td>
                  {#if !@edit}
                    <button class="btn btn-circle btn-xs float-right" :on-click={@delete_field} phx-value-label={key}>
                      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-4 h-4 stroke-current">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  {/if}
                </td>
              </tr>
            {/for}
            <tr>
              <td colspan="3">
                <CreateSection click={@add_field} id="create" />
              </td>
            </tr>
          </tbody>
        </table>
      </Form>
    </div>
    """
    end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end
end