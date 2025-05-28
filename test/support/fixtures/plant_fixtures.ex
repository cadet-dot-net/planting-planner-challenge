defmodule Planter.PlantFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Planter.Plant` context.
  """

  @doc """
  Generate a vegetable.
  """
  def vegetable_fixture(attrs \\ %{}) do
    {:ok, vegetable} =
      attrs
      |> Enum.into(%{
        benefits_from: ["option1", "option2"],
        name: "some name",
        soil_types: ["option1", "option2"]
      })
      |> Planter.Plant.create_vegetable()

    vegetable
  end
end
