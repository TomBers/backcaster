defmodule Section do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, Label, Field}

  prop section, :map
  prop edit, :boolean

  data vals, :map, default: %{"type" => ""}

  prop submit, :event, required: true


  def render(assigns) do
    ~F"""
    {#if @edit}
            <Form for={:vals} submit={@submit}>
            <Field class="field" name="new_value">
                <div class="control">
                    <TextInput class="input input-secondary input-bordered" value={@section["content"]}/>
                        <input class="btn btn-small update-section mx-4" type="submit" value="Update">
                </div>
            </Field>
            <Field class="field" name="title">
                <div class="control">
                    <TextInput class="hidden" value={@section["title"]}/>
                </div>
            </Field>
            </Form>
    {#else}
      {@section["content"]}
    {/if}
    """
  end

end