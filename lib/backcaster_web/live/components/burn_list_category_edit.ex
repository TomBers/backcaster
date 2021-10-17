defmodule BurnListCategoryEdit do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, HiddenInput, Label, Field}

  prop category, :map
  prop parent_pid, :string
  prop delete_item, :event

  data edit, :boolean, default: false
  data edit_category,
       :map,
       default: %{
         "uuid" => "",
         "content" => ""
       }

  def render(assigns) do
    ~F"""
    <span class="emphasis">
      {#if @edit}
        <Form for={:edit_category} submit="submit">
          <Field class="field" name="content">
            <TextInput class="input btn-block text-neutral-content bg-neutral" value={@category.text} id={@id} />
          </Field>
          <Field class="field" name="uuid">
            <HiddenInput value={@id} />
          </Field>
        </Form>
      {#else}
        <div>{@category.text} <button class="btn btn-ghost btn-xs" :on-click="edit">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
            />
          </svg>
        </button>
      <button class="btn btn-ghost btn-xs" :on-click={@delete_item} value={@id} >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
      </button>
      </div>
      {/if}
    </span>
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

  def handle_event("submit", params, socket) do
    send(socket.assigns.parent_pid, params)
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end


end