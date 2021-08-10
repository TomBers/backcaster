defmodule Images do
  use Surface.LiveComponent
  prop images, :map
  prop parent_pid, :string
  prop store_image, :event, required: true
  prop delete_image, :event, required: true

  def render(assigns) do
    ~F"""
    <div class="card bg-secondary">
      <div class="card-body">
          {#if length(Map.keys(@images)) == 0 }
          <ImageUpload store_image={@store_image} parent_pid={@parent_pid} id="imageUploads" />
          {#else}
          <div class="flex w-auto space-x-10 flex-nowrap">
              {#for {id, image} <- @images}
              <div class="artboard artboard-demo">
                  <img src={image["web_path"]} />
                  <button class="btn-sm is-info" :on-click={@delete_image} phx-value-id={id}>
                      X
                  </button>
              </div>
              {/for}
          </div>
          {/if}
      </div>
    </div>
  """
    end

end