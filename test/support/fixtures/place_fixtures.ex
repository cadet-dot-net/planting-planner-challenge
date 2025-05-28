defmodule Planter.PlaceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Planter.Place` context.
  """

  @doc """
  Generate a bed.
  """
  def bed_fixture(attrs \\ %{}) do
    {:ok, bed} =
      attrs
      |> Enum.into(%{
        length: 42,
        soil_type: "some soil_type",
        width: 42,
        x: 42,
        y: 42
      })
      |> Planter.Place.create_bed()

    bed
  end
end
