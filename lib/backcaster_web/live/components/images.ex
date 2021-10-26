defmodule Images do
  use Surface.LiveComponent
  prop images, :map
  prop image_processing, :boolean
  prop parent_pid, :string
  prop store_image, :event, required: true
  prop delete_image, :event, required: true

  def render(assigns) do
    ~F"""
    <div class="card">
      <div class="card-body">
        {#if @image_processing}
          <h1>Uploaded images processing, hit refresh to continue</h1>
        {#else}
          {#if length(Map.keys(@images)) == 0}
            <ImageUpload store_image={@store_image} parent_pid={@parent_pid} id="imageUploads" />
          {#else}
            <div class="grid grid-cols-2 gap-2 p-2 pt-4 bg-base-100">
              {#for {id, image} <- @images}
                <div>
                  <img src={Backcaster.Images.url(image["web_path"])}>
                  <button class="btn btn-circle btn-xs" :on-click={@delete_image} phx-value-id={id}>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-4 h-4 stroke-current">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              {/for}
            </div>
          {/if}
        {/if}
      </div>
    </div>
    """
    end

end