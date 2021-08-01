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
    <div class="card shadow-lg md:card-side bg-secondary">
      <div class="card-body">
        <h2 class="card-title">{@title}</h2>
        <p>{@value}</p>
        <div class="justify-end card-actions">
          <button class="btn-sm btn-secondary" :on-click="edit">
                Edit
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 ml-2 stroke-current">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </button>
        </div>
        <div :if={@edit}>
          <Form for={:vals} submit={@submit} opts={autocomplete: "off"}>
          <Field class="field" name="new value">
            <Label class="label"/>
            <div class="control">
              <TextInput class="input" value={@value}/>
              <input class="btn" type="submit" value="Update" :on-click="edit">
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
    </div>
    """
  end

  def handle_event("edit", _, socket) do
    {:noreply, update(socket, :edit, fn _ -> !socket.assigns.edit end)}
  end

end