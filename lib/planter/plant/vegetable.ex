defmodule Planter.Plant.Vegetable do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plants" do
    field :name, :string
    field :soil_types, {:array, :string}
    field :benefits_from, {:array, :string}
    belongs_to :bed, Planter.Place.Bed

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vegetable, attrs) do
    vegetable
    |> cast(attrs, [:name, :soil_types, :benefits_from])
    |> validate_required([:name, :soil_types, :benefits_from])
  end
end
