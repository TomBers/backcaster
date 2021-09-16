defmodule MilestoneForm do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, DateInput, Label, Field}

  prop title, :string
  prop date, :string
  prop button_text, :string

  data vals, :map, default: %{"name" => "", "email" => ""}

  prop submit, :event, required: true
  prop edit, :event, required: true

  def render(assigns) do
    ~F"""
    <div class="form-control justify-left">
      <br>
      <Form for={:vals} submit={@submit} opts={autocomplete: "off"}>
        <Field class="field" name="title">
          <div class="control">
            <TextInput class="input" value={@title} placeholder="Title" />
          </div>
        </Field>
        <Field name="id">
          <TextInput class="hidden" value={@id} />
        </Field>
        <br>
        <Field class="field" name="date">
          <div class="control">
            <DateInput class="input" value={@date} />
            <br><br>
            <input class="btn btn-secondary btn-block milestone-submit" type="submit" value={@button_text} :on-click={@edit}>
          </div>
        </Field>
      </Form>
    </div>
    """
  end

end