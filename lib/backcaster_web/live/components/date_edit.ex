defmodule DateEdit do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{DateInput, Label, Field}

  prop date, :string
  prop date_start, :string
  prop parent_pid, :string

  data edit, :boolean, default: false
  data due_date,
       :map,
       default: %{
         "date" => ""
       }

  def render(assigns) do
    ~F"""
    <span>
      {#if @edit}
        <Form for={:due_date} submit="submit">
          <Field class="field" name="new_start_date">
            <Label class="label">Start Date</Label>
            <DateInput class="bg-neutral text-neutral-content p-4" value={@date_start} id="date_start_edit" />
          </Field>
          <Field class="field" name="new_date">
            <Label class="label">End Date</Label>
            <DateInput class="bg-neutral text-neutral-content p-4" value={@date} id="date_edit" />
          </Field>
          <br>
          <input class="btn btn-secondary btn-block milestone-submit" type="submit" value="update">
        </Form>
      {#else}
        Due date : {@date} <button class="btn btn-ghost btn-xs" :on-click="edit">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
            />
          </svg>
        </button>
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