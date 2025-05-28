defmodule Planter.Place.Bed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "beds" do
    field :x, :integer
    field :y, :integer
    field :width, :integer
    field :length, :integer
    field :soil_type, :string
    has_many :plants, Planter.Plant.Vegetable

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bed, attrs) do
    bed
    |> cast(attrs, [:x, :y, :width, :length, :soil_type])
    |> validate_required([:x, :y, :width, :length, :soil_type])
  end
end
