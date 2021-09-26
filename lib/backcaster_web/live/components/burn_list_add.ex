defmodule BurnListAdd do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{TextArea, HiddenInput, Label, Field}

  prop add_item_event, :event
  data add_item,
       :map,
       default: %{
         "content" => ""
       }

  def render(assigns) do
    ~F"""
    <span class="emphasis">
        <Form for={:add_item} submit={@add_item_event} opts={autocomplete: "off"}>
          <Field class="field" name="content">
            <TextArea class="textarea h-24" id={@id} rows="4"  opts={placeholder: "(Each line is a new item)"}/>
          </Field>
            <input class="btn milestone-submit" type="submit" value="Submit">
        </Form>
    </span>
    """
  end

end