defmodule Backcaster.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :name, :string
      add :content, :map

      timestamps()
    end
  end
end
