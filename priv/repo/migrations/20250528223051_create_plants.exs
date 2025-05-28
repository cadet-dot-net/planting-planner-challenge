defmodule Planter.Repo.Migrations.CreatePlants do
  use Ecto.Migration

  def change do
    create table(:plants) do
      add :name, :string
      add :soil_types, {:array, :string}
      add :benefits_from, {:array, :string}
      add :bed_id, references(:beds, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:plants, [:bed_id])
  end
end
