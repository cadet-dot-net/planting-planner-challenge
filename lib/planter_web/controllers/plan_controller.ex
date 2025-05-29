defmodule PlanterWeb.PlanController do
  use PlanterWeb, :controller

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

  def create(conn, %{"plan" => plan_params}) do
    with {:ok, %Plan{} = plan} <- Garden.create_plan(conn.assigns.current_scope, plan_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/plans/#{plan}")
      |> render(:show, plan: plan)
    end
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
end
