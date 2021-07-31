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
        <button class="button is-info" :on-click="edit">Edit</button>
        <div :if={@edit}>
          <Form for={:vals} submit={@submit} opts={autocomplete: "off"}>
          <Field class="field" name="new value">
            <Label class="label"/>
            <div class="control">
              <TextInput class="input" value={@value}/>
            </div>
          </Field>
          <Field class="field" name="title">
            <div class="control">
              <TextInput class="hidden" value={@title}/>
            </div>
          </Field>
          <input type="submit" value="Submit" :on-click="edit">
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

defmodule BackcasterWeb.BackcastLive do
  use Surface.LiveView

  alias Backcaster.SampleData

  def mount(%{"id" => id}, _session, socket) do
    socket =
      socket
      |> assign(:backcast, SampleData.sample(id))
    {:ok, socket}
  end

  def handle_event("update_field", %{"vals" => %{"new value" => new_val, "title" => title}}, socket) do
    new_backcast = Map.replace(socket.assigns.backcast, title, new_val)
    {:noreply, assign(socket, :backcast, new_backcast)}
  end


end