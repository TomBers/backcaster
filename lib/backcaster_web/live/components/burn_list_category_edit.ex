defmodule BurnListCategoryEdit do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, HiddenInput, Field}

  prop category, :map
  prop parent_pid, :string
  prop board_id, :string
  prop delete_item, :event
  prop num_open, :integer
  prop num_closed, :integer

  data edit, :boolean, default: false
  data show_address, :boolean, default: false
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
        <div class="text-3xl break-all">
          {@category.text}
          <span class="float-right">
            <div data-tip="Edit list name" class="tooltip tooltip-left"><button class="btn btn-ghost btn-xs" :on-click="edit">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
                  />
                </svg>
              </button></div>
            <div data-tip="Delete list" class="tooltip tooltip-left">
              <button class="btn btn-ghost btn-xs" :on-click={@delete_item} value={@id}>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </button></div>
            <div data-tip="Webhook endpoint" class="tooltip tooltip-left">
              <button class="btn btn-ghost btn-xs" :on-click="show_address">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"
                  />
                </svg>
              </button>
            </div>
          </span>

          {#if @show_address}
            <p class="small-instructions word-break">This list can be populared by making a POST request to this url:
              <code class="small-instructions-code">{"#{BackcasterWeb.Endpoint.url()}#{BackcasterWeb.Router.Helpers.burn_list_path(BackcasterWeb.Endpoint, :create_item, @board_id, @id)}"}</code>
              <br>(e.g a webhook endpoint for populating Github issues)</p>
          {/if}
        </div>
      {/if}
      <div class="text-sm mb-2">{@num_open} open | {@num_closed} closed</div>
    </span>
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

  def handle_event("show_address", _, socket) do
    {:noreply, update(socket, :show_address, fn _ -> !socket.assigns.show_address end)}
  end

  def handle_event("submit", params, socket) do
    send(socket.assigns.parent_pid, params)
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end


end