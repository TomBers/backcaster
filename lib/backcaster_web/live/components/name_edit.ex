defmodule NameEdit do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{TextArea, TextInput, HiddenInput, Label, Field}

  prop board_name, :string
  prop parent_pid, :string
  prop rename_error, :string

  data edit, :boolean, default: false
  data name_change,
       :map,
       default: %{
         "new_board_name" => ""
       }

  def render(assigns) do
    ~F"""
    <div class="emphasis mt-6 mb-6 ml-2 pl-10">
      {#if @edit}
        <Form for={:name_change} submit="submit">
          <Field class="field" name="new_board_name">
            <div class="relative">
              <TextInput
                class="input btn-block text-neutral-content bg-neutral border-primary"
                value={@board_name}
                id={@board_name}
              />
              <button
                class="absolute top-0 right-0 rounded-l-none btn btn-primary"
                type="submit"
                phx-hook="removeOldCookie"
                data-board-name={@board_name}
                id="renameBoard"
              >Save</button>
            </div>
          </Field>
        </Form>
        <button class="btn btn-xs" :on-click="cancel">Cancel</button>
      {#else}
        <span class="inline-edit-content word-break tooltip tooltip-right big-template-text" data-tip="Edit">
          {@board_name} <button class="btn btn-ghost btn-xs" :on-click="edit">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
              />
            </svg>
          </button>
          <p>{@rename_error}</p>
        </span>
      {/if}
    </div>
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

  def handle_event("cancel", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> false end)}
  end

  def handle_event("submit", params, socket) do
    send(socket.assigns.parent_pid, params)
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

end