defmodule Planter.Knowledge do
  require Logger

  alias Planter.Plant

  @table_name :knowledge

  @spec list_plants() :: list()
  def list_plants() do
    :ets.tab2list(@table_name)
  end

  @spec get_plant(String.t()) :: map()
  def get_plant(name) do
    case :ets.lookup(@table_name, name) do
      [{^name, data}] -> data
      _ -> nil
    end
  end

  def store_plants() do
    with [_ | _] = polled_plants <- list_plants() do
      Enum.each(polled_plants, &update_or_store/1)
    end
  end

  defp update_or_store({name, attrs}) do
    vegetable = Plant.get_vegetable!(name)
    Plant.update_vegetable(vegetable, attrs)
  rescue
    _ ->
      attrs
      |> Map.put(:name, name)
      |> Plant.create_vegetable()
  end
end
