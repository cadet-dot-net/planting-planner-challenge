defmodule PlanterWeb.PlanJSON do
  alias Planter.Garden.Plan

  @doc """
  Renders a list of plans.
  """
  def index(%{plans: plans}) do
    %{data: for(plan <- plans, do: data(plan))}
  end

  @doc """
  Renders a single plan.
  """
  def show(%{plan: plan}) do
    %{data: data(plan)}
  end

  defp data(%Plan{} = plan) do
    %{
      id: plan.id,
      data: plan.data
    }
  end
end
