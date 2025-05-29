defmodule PlanterWeb.BedController do
  use PlanterWeb, :controller

  alias Util.CsvParser
  alias Planter.Place
  alias Planter.Place.Bed

  action_fallback PlanterWeb.FallbackController

  def index(conn, _params) do
    beds = Place.list_beds()
    render(conn, :index, beds: beds)
  end

  def create(conn, %{"file" => file}) do
    %Plug.Upload{path: tmp_path} = file

    case CsvParser.parse_rows(tmp_path, &parse_bed_row/1) do
      [] -> json(conn, %{"ok" => "Beds created"})
      errors -> json(conn, %{"ok" => "Failed to create beds: #{errors}"})
    end
  rescue
    reason ->
      json(conn, %{"error" => "Failed to parse file: #{inspect(reason)}"})
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

  defp parse_bed_row([st, x, y, w, l]) do
    bed = %{
      soil_type: st,
      x: String.to_integer(x),
      y: String.to_integer(y),
      width: String.to_float(w),
      length: String.to_float(l)
    }

    Place.create_bed(bed)
  end
end
