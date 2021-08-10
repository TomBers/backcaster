defmodule ImageUpload do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, DateInput, Label, Field}

  prop store_image, :event, required: true
  prop parent_pid, :string
  data changeset, :map, default: %{"images" => ""}

  @impl true
  def mount(socket) do
    {:ok, allow_upload(socket, :images, accept: ~w(.png .jpg .jpeg), max_entries: 4)}
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
        dest = Path.join("priv/static/images", "#{entry.uuid}.#{ext(entry)}")
        File.cp!(meta.path, dest)
        path =  Path.join("/images", "#{entry.uuid}.#{ext(entry)}")
        params =
          socket.assigns.store_image
          |> Map.put("web_path", path)
          |> Map.put("file_path", dest)

        send(socket.assigns.parent_pid, params)
      end
    )
  end

end