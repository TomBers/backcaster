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
      <Form for={:template} change={@change_template}>
        <div data-tip="How to describe your goal" class="tooltip tooltip-bottom lg:float-right">
          <Select
            form="theme"
            field="template"
            selected={@backcast["template"]}
            options={make_options()}
            class="select select-lg lg:float-right"
          />
        </div>
      </Form>

      {#case @backcast["template"]}
        {#match "startup"}
          <Startup backcast={@backcast} parent_pid={self()} id="startup" />
        {#match "simple"}
          <Simple backcast={@backcast} parent_pid={self()} id="art" />
        {#match "fivew"}
          <FiveW backcast={@backcast} parent_pid={self()} id="fivew" />
        {#match "swot"}
          <Swot backcast={@backcast} parent_pid={self()} id="swot" />
        {#match "freeform"}
          <Freeform backcast={@backcast} parent_pid={self()} id="freeform" />
        {#match "personal"}
          <Personal backcast={@backcast} parent_pid={self()} id="personal" />
        {#match "user-story"}
          <UserStory backcast={@backcast} parent_pid={self()} id="user-story" />
        {#match _}
          <Startup backcast={@backcast} parent_pid={self()} id="startup" />
      {/case}

      <br>
      <br>
      <SummaryModal template={@backcast["template"]} backcast={@backcast} id="summaryModal" />
    </div>
    """
    end

  def make_options do
    Backcaster.SampleData.templates
    |> Enum.flat_map(fn cat -> %{"#{String.capitalize(cat)} template" => cat} end)
  end

end