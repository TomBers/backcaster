defmodule Backcaster.Backcast.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :content, :map
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
  end
end
