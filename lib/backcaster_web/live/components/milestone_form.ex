defmodule MilestoneForm do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, DateInput, Label, Field}

  prop title, :string
  prop date, :string

  data vals, :map, default: %{"name" => "", "email" => ""}

  prop submit, :event, required: true
  prop edit, :event, required: true

  def render(assigns) do
    ~F"""
      <div class="card-body">
        <h2 class="card-title">{@title}</h2>
        <p>{@date}</p>
        <div class="justify-end card-actions">
        </div>
          <Form for={:vals} submit={@submit} opts={autocomplete: "off"}>
          <Field class="field" name="title">
            <div class="control">
              <TextInput class="input" value={@title}/>
            </div>
          </Field>
          <Field name="id">
            <TextInput class="hidden" value={@id}/>
          </Field>
          <Field class="field" name="date">
            <div class="control">
              <DateInput class="input" value={@date}/>
              <input class="btn" type="submit" value="Update" :on-click={@edit} >
            </div>
          </Field>
        </Form>
      </div>
    """
  end

end