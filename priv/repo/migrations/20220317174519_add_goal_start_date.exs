defmodule Backcaster.Repo.Migrations.AddGoalStartDate do
  use Ecto.Migration

  def change do
    alter table(:boards) do
      add :goal_start_date, :date
    end
  end
end
