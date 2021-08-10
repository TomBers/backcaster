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
          <div class="grid grid-cols-2 gap-2 p-2 pt-4 bg-base-100">
              {#for {id, image} <- @images}
                <div>
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