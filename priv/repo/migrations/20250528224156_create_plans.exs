defmodule Planter.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :area, :float
      add :bed_id, references(:beds, on_delete: :nothing)
      add :plant_id, references(:plants, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:plans, [:user_id])
    create index(:plans, [:bed_id])
    create index(:plans, [:plant_id])
  end
end
