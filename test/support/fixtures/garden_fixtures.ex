defmodule Planter.GardenFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Planter.Garden` context.
  """

  @doc """
  Generate a plan.
  """
  def plan_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        area: 42
      })

    {:ok, plan} = Planter.Garden.create_plan(scope, attrs)
    plan
  end
end
