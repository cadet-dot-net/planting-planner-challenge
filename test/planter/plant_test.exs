defmodule Planter.PlantTest do
  use Planter.DataCase

  alias Planter.Plant

  describe "plants" do
    alias Planter.Plant.Vegetable

    import Planter.PlantFixtures

    @invalid_attrs %{name: nil, soil_types: nil, benefits_from: nil}

    test "list_plants/0 returns all plants" do
      vegetable = vegetable_fixture()
      assert Plant.list_plants() == [vegetable]
    end

    test "get_vegetable!/1 returns the vegetable with given id" do
      vegetable = vegetable_fixture()
      assert Plant.get_vegetable!(vegetable.id) == vegetable
    end

    test "create_vegetable/1 with valid data creates a vegetable" do
      valid_attrs = %{name: "some name", soil_types: ["option1", "option2"], benefits_from: ["option1", "option2"]}

      assert {:ok, %Vegetable{} = vegetable} = Plant.create_vegetable(valid_attrs)
      assert vegetable.name == "some name"
      assert vegetable.soil_types == ["option1", "option2"]
      assert vegetable.benefits_from == ["option1", "option2"]
    end

    test "create_vegetable/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Plant.create_vegetable(@invalid_attrs)
    end

    test "update_vegetable/2 with valid data updates the vegetable" do
      vegetable = vegetable_fixture()
      update_attrs = %{name: "some updated name", soil_types: ["option1"], benefits_from: ["option1"]}

      assert {:ok, %Vegetable{} = vegetable} = Plant.update_vegetable(vegetable, update_attrs)
      assert vegetable.name == "some updated name"
      assert vegetable.soil_types == ["option1"]
      assert vegetable.benefits_from == ["option1"]
    end

    test "update_vegetable/2 with invalid data returns error changeset" do
      vegetable = vegetable_fixture()
      assert {:error, %Ecto.Changeset{}} = Plant.update_vegetable(vegetable, @invalid_attrs)
      assert vegetable == Plant.get_vegetable!(vegetable.id)
    end

    test "delete_vegetable/1 deletes the vegetable" do
      vegetable = vegetable_fixture()
      assert {:ok, %Vegetable{}} = Plant.delete_vegetable(vegetable)
      assert_raise Ecto.NoResultsError, fn -> Plant.get_vegetable!(vegetable.id) end
    end

    test "change_vegetable/1 returns a vegetable changeset" do
      vegetable = vegetable_fixture()
      assert %Ecto.Changeset{} = Plant.change_vegetable(vegetable)
    end
  end
end
