defmodule BurnListEdit do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{TextArea, HiddenInput, Label, Field}

  prop item, :map
  prop parent_pid, :string
  prop delete_item, :event

  data edit, :boolean, default: false
  data edit_item,
       :map,
       default: %{
         "uuid" => "",
         "content" => ""
       }

  def render(assigns) do
    ~F"""
    <span class="emphasis">
      {#if @edit}
        <Form for={:edit_item} submit="submit">
          <div class="input-group input-group-lg">
            <Field class="field" name="content">
              <TextArea class="textarea input-bordered text-sm" value={@item.text} rows="3" cols="34" id={@id} />
            </Field>
            <Field class="field" name="uuid">
              <HiddenInput value={@id} />
            </Field>
            <button class="btn btn-lg" type="submit">Save</button>
          </div>
        </Form>
      {#else}
        <div class="mb-4 burnlist-handle">
          <div class={get_handle_colour(calc_age(@item.updated_at))}>
            <div class="col-span-9 flex flex-col justify-center">
              <div class="pl-2 pt-2 pb-2 break-word text-lg">{@item.text}</div>
              {#if length(get_labels(@item)) > 0}
                <div class="m-2">
                  {#for label <- get_labels(@item)}
                    <span class={get_badge_class(label)}>{label}</span>
                  {/for}
                </div>
              {/if}
            </div>

            <div class="py-2">
              <button class="btn btn-ghost btn-xs" :on-click="edit">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
                  />
                </svg>
              </button>
              <button class="btn btn-ghost btn-xs" :on-click={@delete_item} value={@id}>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </button>
            </div>
          </div>
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

  def calc_age(created_at) do
    Date.diff(Date.utc_today(), created_at)
  end

  def get_labels(item) do
    Map.get(item, :labels, [])
  end

  def get_badge_class(label) do
    case label do
      "Requires response" -> "badge badge-sm badge-error"
      "Simple Task" -> "badge badge-sm badge-info"
      "Needs thought" -> "badge badge-sm badge-primary"
      "Needs feedback" -> "badge badge-sm badge-secondary"
      _ -> "badge badge-sm"
    end
  end

  def get_handle_colour(age) when age > 7 do
    "grid grid-cols-10 border-2 border-rose-500"
  end

  def get_handle_colour(age) when age > 3 do
    "grid grid-cols-10 border-2 border-orange-300"
  end

  def get_handle_colour(age) do
    "grid grid-cols-10 border-2"
  end

end