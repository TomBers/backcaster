defmodule Backcaster.Repo.Migrations.AddGoalDate do
  use Ecto.Migration

  def change do
    alter table(:boards) do
      add :goal_date, :date
    end
  end
end
