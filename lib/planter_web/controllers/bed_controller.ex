defmodule PlanterWeb.BedController do
  use PlanterWeb, :controller

  alias Planter.Place
  alias Planter.Place.Bed

  action_fallback PlanterWeb.FallbackController

  def index(conn, _params) do
    beds = Place.list_beds()
    render(conn, :index, beds: beds)
  end

  def create(conn, %{"bed" => bed_params}) do
    with {:ok, %Bed{} = bed} <- Place.create_bed(bed_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/beds/#{bed}")
      |> render(:show, bed: bed)
    end
  end

  def show(conn, %{"id" => id}) do
    bed = Place.get_bed!(id)
    render(conn, :show, bed: bed)
  end

  def update(conn, %{"id" => id, "bed" => bed_params}) do
    bed = Place.get_bed!(id)

    with {:ok, %Bed{} = bed} <- Place.update_bed(bed, bed_params) do
      render(conn, :show, bed: bed)
    end
  end

  def delete(conn, %{"id" => id}) do
    bed = Place.get_bed!(id)

    with {:ok, %Bed{}} <- Place.delete_bed(bed) do
      send_resp(conn, :no_content, "")
    end
  end
end
