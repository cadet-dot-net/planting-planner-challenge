defmodule Planter.PlaceTest do
  use Planter.DataCase

  alias Planter.Place

  describe "beds" do
    alias Planter.Place.Bed

    import Planter.PlaceFixtures

    @invalid_attrs %{length: nil, width: nil, y: nil, x: nil, soil_type: nil}

    test "list_beds/0 returns all beds" do
      bed = bed_fixture()
      assert Place.list_beds() == [bed]
    end

    test "get_bed!/1 returns the bed with given id" do
      bed = bed_fixture()
      assert Place.get_bed!(bed.id) == bed
    end

    test "create_bed/1 with valid data creates a bed" do
      valid_attrs = %{length: 42, width: 42, y: 42, x: 42, soil_type: "some soil_type"}

      assert {:ok, %Bed{} = bed} = Place.create_bed(valid_attrs)
      assert bed.length == 42
      assert bed.width == 42
      assert bed.y == 42
      assert bed.x == 42
      assert bed.soil_type == "some soil_type"
    end

    test "create_bed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Place.create_bed(@invalid_attrs)
    end

    test "update_bed/2 with valid data updates the bed" do
      bed = bed_fixture()
      update_attrs = %{length: 43, width: 43, y: 43, x: 43, soil_type: "some updated soil_type"}

      assert {:ok, %Bed{} = bed} = Place.update_bed(bed, update_attrs)
      assert bed.length == 43
      assert bed.width == 43
      assert bed.y == 43
      assert bed.x == 43
      assert bed.soil_type == "some updated soil_type"
    end

    test "update_bed/2 with invalid data returns error changeset" do
      bed = bed_fixture()
      assert {:error, %Ecto.Changeset{}} = Place.update_bed(bed, @invalid_attrs)
      assert bed == Place.get_bed!(bed.id)
    end

    test "delete_bed/1 deletes the bed" do
      bed = bed_fixture()
      assert {:ok, %Bed{}} = Place.delete_bed(bed)
      assert_raise Ecto.NoResultsError, fn -> Place.get_bed!(bed.id) end
    end

    test "change_bed/1 returns a bed changeset" do
      bed = bed_fixture()
      assert %Ecto.Changeset{} = Place.change_bed(bed)
    end
  end
end
