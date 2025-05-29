defmodule PlanterWeb.BedJSON do
  alias Planter.Place.Bed

  @doc """
  Renders a list of beds.
  """
  def index(%{beds: beds}) do
    %{data: for(bed <- beds, do: data(bed))}
  end

  @doc """
  Renders a single bed.
  """
  def show(%{bed: bed}) do
    %{data: data(bed)}
  end

  defp data(%Bed{} = bed) do
    %{
      id: bed.id,
      data: bed.data
    }
  end
end
