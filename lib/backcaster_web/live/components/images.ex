defmodule Images do
  use Surface.LiveComponent
  prop images, :map
  prop parent_pid, :string
  prop store_image, :event, required: true

  def render(assigns) do
    ~F"""
        <div class="card shadow-lg md:card-side bg-secondary">
          <div class="card-body">
    {#if length(Map.keys(@images)) == 0 }
      <ImageUpload store_image={@store_image} parent_pid={@parent_pid} id="imageUploads" />
    {#else}
        {#for {id, image} <- @images}
          <img src={image["path"]} />
      {/for}
    {/if}

  </div>
    </div>

  """
    end

end