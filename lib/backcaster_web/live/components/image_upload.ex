defmodule ImageUpload do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, DateInput, Label, Field}

  prop store_image, :event, required: true
  prop test, :string
  data changeset, :map, default: %{"name" => "", "email" => ""}

  @impl true
  def mount(socket) do
    {:ok, allow_upload(socket, :images, accept: ~w(.png .jpg .jpeg), max_entries: 2)}
  end

  def handle_event("test", params, socket) do
    IO.inspect("Test")
    IO.inspect(socket.assigns.store_image)
    {:noreply, socket}
  end

  def handle_event("validate", params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", params, socket) do
    consume_images(socket)
    {:noreply, socket}
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  def consume_images(socket) do
    consume_uploaded_entries(
      socket,
      :images,
      fn meta, entry ->
        # TODO - think of a better way to deal with temp files
        dest = Path.join("priv/static/images", "#{entry.uuid}.#{ext(entry)}")
        File.cp!(meta.path, dest)
#        TODO - store the new file location against the board
      end
    )
  end

end