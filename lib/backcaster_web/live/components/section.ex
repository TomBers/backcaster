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
    <button class="btn btn-sm btn-secondary edit-section" :on-click="edit">
    Edit
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 ml-2 stroke-current">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
    </svg>
    </button>
    <div :if={@edit}>
    <Form for={:vals} submit={@submit} opts={autocomplete: "off"}>
    <Field class="field" name="new_value">
        <Label class="label"/>
        <div class="control">
            <TextInput class="input input-secondary input-bordered" value={@value}/>
                <input class="btn update-section" type="submit" value="Update" :on-click="edit">
        </div>
    </Field>
    <Field class="field" name="title">
        <div class="control">
            <TextInput class="hidden" value={@title}/>
        </div>
    </Field>
    </Form>
    </div>

    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

end