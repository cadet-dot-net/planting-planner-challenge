defmodule PlanterWeb.BedControllerTest do
  use PlanterWeb.ConnCase

  import Planter.PlaceFixtures
  alias Planter.Place.Bed

  @create_attrs %{
    data: ["option1", "option2"]
  }
  @update_attrs %{
    data: ["option1"]
  }
  @invalid_attrs %{data: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all beds", %{conn: conn} do
      conn = get(conn, ~p"/api/beds")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bed" do
    test "renders bed when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/beds", bed: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/beds/#{id}")

      assert %{
               "id" => ^id,
               "data" => ["option1", "option2"]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/beds", bed: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bed" do
    setup [:create_bed]

    test "renders bed when data is valid", %{conn: conn, bed: %Bed{id: id} = bed} do
      conn = put(conn, ~p"/api/beds/#{bed}", bed: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/beds/#{id}")

      assert %{
               "id" => ^id,
               "data" => ["option1"]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bed: bed} do
      conn = put(conn, ~p"/api/beds/#{bed}", bed: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bed" do
    setup [:create_bed]

    test "deletes chosen bed", %{conn: conn, bed: bed} do
      conn = delete(conn, ~p"/api/beds/#{bed}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/beds/#{bed}")
      end
    end
  end

  defp create_bed(_) do
    bed = bed_fixture()

    %{bed: bed}
  end
end
