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
                  <img src={Backcaster.Images.url(image["web_path"])} />
                  <button class="btn btn-circle btn-xs" :on-click={@delete_image} phx-value-id={id}>
                  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-4 h-4 stroke-current">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                  </svg>
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