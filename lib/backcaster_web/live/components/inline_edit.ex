defmodule InlineEdit do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{TextArea, TextInput, HiddenInput, Label, Field}

  prop backcast, :map
  prop category, :string
  prop parent_pid, :string
  prop use_text_area, :boolean, default: false
  prop show_edit, :boolean, default: true

  data edit, :boolean, default: false
  data vals,
       :map,
       default: %{
         "category" => "",
         "content" => ""
       }

  def render(assigns) do
    ~F"""
    <span class="emphasis">
      {#if @edit}
        <Form for={:vals} submit="submit">
          <Field class="field" name="content">
            {#if @use_text_area}
              <TextArea
                class="textarea textarea-primary h-16 w-full my-2"
                id={@category}
                rows="4"
                value={get_content(@backcast, @category)}
                opts={placeholder: "(Add summary)"}
              />
              <input class="btn milestone-submit" type="submit" value="Update">
            {#else}
              <div class="relative">
                <TextInput
                  class="input btn-block text-neutral-content bg-neutral border-primary"
                  value={get_content(@backcast, @category)}
                  id={@category}
                />
                <button class="absolute top-0 right-0 rounded-l-none btn btn-primary" type="submit">Save</button>
              </div>
            {/if}
          </Field>
          <Field class="field" name="category">
            <HiddenInput value={@category} />
          </Field>
        </Form>
        <button class="btn btn-xs" :on-click="cancel">Cancel</button>
      {#else}
        {#if @show_edit}
          <span class="inline-edit-content word-break tooltip tooltip-right" data-tip="Edit">
            {raw(get_content_or_placeholder(@backcast, @category))}
            {#if @use_text_area}
              <br>
            {/if}
            <button class="btn btn-ghost btn-xs" :on-click="edit">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
                />
              </svg>
            </button>
          </span>
        {#else}
          <span class="inline-edit-content word-break">
            {raw(get_content_or_placeholder(@backcast, @category))}
          </span>
        {/if}
      {/if}
    </span>
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

  def get_content(backcast, category) do
    card = Map.get(backcast["cards"], category, %{"content" => ""})
    card["content"]
  end

#  TODO - replace newlines with breaks (make the text html)
  def get_content_or_placeholder(backcast, category) do
    content = get_content(backcast, category)
    if is_nil(content) or content == "" do
      "_____"
    else
#    TODO - this is a bit of a hack see if there is a better way
      String.replace(content, "\r\n", "<br>", global: true)
      |> String.replace("\n", "<br>", global: true)
    end
  end

end