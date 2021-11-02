defmodule :"Elixir.Backcaster.Repo.Migrations.Add-unique-index-to-board-name" do
  use Ecto.Migration

  def change do
    create unique_index(:boards, [:name])
  end
end
