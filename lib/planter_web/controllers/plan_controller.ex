defmodule PlanterWeb.PlanController do
  use PlanterWeb, :controller

  alias Planter.Accounts.{Scope, User}
  alias Util.CsvParser
  alias Plug.Conn
  alias Planter.{Garden, Place}
  alias Planter.Garden.Plan

  action_fallback PlanterWeb.FallbackController

  @base_score 10

  def index(%Conn{assigns: %{current_scope: scope}} = conn, _params) do
    plans = Garden.list_plans(scope)
    render(conn, :index, plans: plans)
  end

  def index(conn, _params) do
    plans = Garden.list_plans()
    render(conn, :index, plans: plans)
  end

  def create(conn, %{"file" => file}) do
    %Plug.Upload{path: tmp_path} = file

    case CsvParser.parse_rows(tmp_path, &parse_plan_row(&1, conn.assigns[:current_scope])) do
      [] -> json(conn, %{"ok" => "Plan created"})
      _ -> json(conn, %{"error" => "Failed to create plan"})
    end
  rescue
    reason ->
      json(conn, %{"error" => "Failed to parse file: #{inspect(reason)}"})
  end

  def score(conn, %{"id" => id}) do
    %Plan{area: area, bed_id: bed_id} =  Garden.get_plan!(id)
    %{plants: plants, width: width, length: length, soil_type: soil_type} =
      Place.get_bed!(bed_id)

    final_score =
      @base_score +
        score_happy_plants(plants) +
        score_bed_planted((width * length), area) -
        score_unhappy_plants(plants, soil_type)

    json(conn, %{"ok" => "Score: #{final_score}"})
  end

  def show(conn, %{"id" => id}) do
    plan = Garden.get_plan!(conn.assigns.current_scope, id)
    render(conn, :show, plan: plan)
  end

  def update(conn, %{"id" => id, "plan" => plan_params}) do
    plan = Garden.get_plan!(conn.assigns.current_scope, id)

    with {:ok, %Plan{} = plan} <- Garden.update_plan(conn.assigns.current_scope, plan, plan_params) do
      render(conn, :show, plan: plan)
    end
  end

  def delete(conn, %{"id" => id}) do
    plan = Garden.get_plan!(conn.assigns.current_scope, id)

    with {:ok, %Plan{}} <- Garden.delete_plan(conn.assigns.current_scope, plan) do
      send_resp(conn, :no_content, "")
    end
  end

  defp parse_plan_row([_id, plant_name, area], scope) do
    scope = scope || %Scope{user: %User{id: nil}}

    %{soil_types: soil_types} = Planter.Knowledge.get_plant(plant_name)
    area = String.to_float(area)
    bed = Planter.Place.get_bed_by_soil_type_area(soil_types, area)
    plant = Planter.Plant.get_vegetable!(plant_name)

    plan_params = %{
      area: area,
      bed_id: bed.id,
      plant_id: plant.id
    }

    Garden.create_plan(scope, plan_params)
  end

  defp score_happy_plants(plants) do
    Enum.count(plants, fn %{benefits_from: friends} ->
      Enum.any?(friends, &Enum.member?(plants, &1))
    end)
  end

  defp score_unhappy_plants(plants, soil_type) do
    Enum.count(plants, fn %{soil_types: preferred_soil_types} ->
      soil_type not in preferred_soil_types
    end)
  end

  defp score_bed_planted(bed_area, planted_area) when bed_area > planted_area do
    1
  end

  defp score_bed_planted(_bed_area, _planted_area) do
    0
  end
end
