defmodule PlanterWeb.PlanController do
  use PlanterWeb, :controller

  alias Planter.Accounts.{Scope, User}
  alias Util.CsvParser
  alias Plug.Conn
  alias Planter.Garden
  alias Planter.Garden.Plan

  action_fallback PlanterWeb.FallbackController

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
end
