defmodule Backcaster.Backcast.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :content, :map
    field :name, :string
    field :goal_date, :date
    field :goal_start_date, :date
    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :content, :goal_date, :goal_start_date])
    |> validate_required([:name, :content])
    |> unique_constraint(:name)
  end
end
