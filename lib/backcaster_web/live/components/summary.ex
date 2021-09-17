defmodule Summary do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.{Select}

  prop backcast, :map
  prop parent_pid, :string
  prop change_template, :event

  data template,
       :map,
       default: %{
         "template" => ""
       }

  def render(assigns) do
    ~F"""
    <div class="card shadow-lglg:p-10 xl:grid-cols-2 lg:bg-base-200 rounded-box p-8 text-xl">
      <Form for={:template} change={@change_template} >
        <Select form="theme" field="template" selected={@backcast["template"]} options={make_options()} class="select float-right" />
      </Form>

      {#case @backcast["template"]}
        {#match "startup"}
          <Startup board={@board} backcast={@backcast} parent_pid={self()} id="startup" />
        {#match "art"}
          <Art board={@board} backcast={@backcast} parent_pid={self()} id="art" />
      {/case}
    </div>
    """
    end

  def make_options do
    Backcaster.SampleData.templates
    |> Enum.flat_map(fn cat -> %{"#{String.capitalize(cat)} template" => cat} end)
    |> Map.new()
  end

end