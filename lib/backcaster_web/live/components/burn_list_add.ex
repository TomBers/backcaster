defmodule BurnListAdd do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, HiddenInput, Label, Field}

  prop add_item_event, :event

  data text_val, :string, default: ""

  data add_item,
       :map,
       default: %{
         "content" => ""
       }

# TODO - the input is not clearing on submit
  def handle_event("clear", _params, socket) do
    {:noreply, socket |> assign(:text_val, "")}
  end

  def render(assigns) do
    ~F"""
    <span class="emphasis">
        <Form for={:add_item} submit={@add_item_event}>
          <Field class="field" name="content">
            <TextInput class="input btn-block text-neutral-content bg-neutral" value={@text_val} id={@id} />
          </Field>
            <input class="btn btn-primary btn-block milestone-submit" type="submit" value="Add" :on-click="clear">
        </Form>
    </span>
    """
  end

end