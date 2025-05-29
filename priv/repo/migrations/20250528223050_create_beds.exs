defmodule Planter.Repo.Migrations.CreateBeds do
  use Ecto.Migration

  def change do
    create table(:beds) do
      add :x, :integer
      add :y, :integer
      add :width, :float
      add :length, :float
      add :soil_type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
