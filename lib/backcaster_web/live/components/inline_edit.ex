defmodule InlineEdit do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, HiddenInput, Label, Field}

  prop backcast, :map
  prop category, :string
  prop parent_pid, :string

  data edit, :boolean, default: false
  data vals,
       :map,
       default: %{
         "category" => "",
         "content" => ""
       }

  def render(assigns) do
    ~F"""
      <span>
        {#if @edit}
          <Form for={:vals} submit="submit" >
            <Field class="field" name="content">
                <TextInput class="input" value={get_content(@backcast, @category)} id={@category}  />
            </Field>
            <Field class="field" name="category">
                <HiddenInput value={@category} />
            </Field>
          </Form>
        {#else}
          {get_content_or_placeholder(@backcast, @category)} <button class="btn btn-ghost btn-xs" :on-click="edit" >
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

  def get_content(backcast, category) do
    content = backcast["cards"][category]["content"]
  end

  def get_content_or_placeholder(backcast, category) do
    content = get_content(backcast, category)
    if is_nil(content) or content == "" do
      "_______"
    else
      content
    end
  end

end