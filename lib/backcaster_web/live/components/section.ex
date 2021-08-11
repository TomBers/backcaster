defmodule Section do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, Label, Field}

  prop title, :string
  prop value, :string

  data vals, :map, default: %{"name" => "", "email" => ""}

  data edit, :boolean, default: false
  prop submit, :event, required: true

  def render(assigns) do
    ~F"""
    <label for={@id} class="btn btn-sm btn-secondary modal-button">Edit</label>
    <input type="checkbox" id={@id} class="modal-toggle">
    <div class="modal">
    <div class="modal-box">
            <Form for={:vals} submit={@submit} opts={autocomplete: "off"}>
            <Field class="field" name="new_value">
                <div class="control">
                    <TextInput class="input input-secondary input-bordered" value={@value}/>
                        <input class="btn update-section mx-4" type="submit" value="Update" :on-click="edit">
                        <label for={@id} class="btn btn-circle btn-xs">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-4 h-4 stroke-current">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
              </label>
                </div>
            </Field>
            <Field class="field" name="title">
                <div class="control">
                    <TextInput class="hidden" value={@title}/>
                </div>
            </Field>
            </Form>
    </div>
    </div>

    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

end