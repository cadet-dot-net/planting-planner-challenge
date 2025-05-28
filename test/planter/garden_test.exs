defmodule Planter.GardenTest do
  use Planter.DataCase

  alias Planter.Garden

  describe "plans" do
    alias Planter.Garden.Plan

    import Planter.AccountsFixtures, only: [user_scope_fixture: 0]
    import Planter.GardenFixtures

    @invalid_attrs %{area: nil}

    test "list_plans/1 returns all scoped plans" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      plan = plan_fixture(scope)
      other_plan = plan_fixture(other_scope)
      assert Garden.list_plans(scope) == [plan]
      assert Garden.list_plans(other_scope) == [other_plan]
    end

    test "get_plan!/2 returns the plan with given id" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)
      other_scope = user_scope_fixture()
      assert Garden.get_plan!(scope, plan.id) == plan
      assert_raise Ecto.NoResultsError, fn -> Garden.get_plan!(other_scope, plan.id) end
    end

    test "create_plan/2 with valid data creates a plan" do
      valid_attrs = %{area: 42}
      scope = user_scope_fixture()

      assert {:ok, %Plan{} = plan} = Garden.create_plan(scope, valid_attrs)
      assert plan.area == 42
      assert plan.user_id == scope.user.id
    end

    test "create_plan/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Garden.create_plan(scope, @invalid_attrs)
    end

    test "update_plan/3 with valid data updates the plan" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)
      update_attrs = %{area: 43}

      assert {:ok, %Plan{} = plan} = Garden.update_plan(scope, plan, update_attrs)
      assert plan.area == 43
    end

    test "update_plan/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      plan = plan_fixture(scope)

      assert_raise MatchError, fn ->
        Garden.update_plan(other_scope, plan, %{})
      end
    end

    test "update_plan/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Garden.update_plan(scope, plan, @invalid_attrs)
      assert plan == Garden.get_plan!(scope, plan.id)
    end

    test "delete_plan/2 deletes the plan" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)
      assert {:ok, %Plan{}} = Garden.delete_plan(scope, plan)
      assert_raise Ecto.NoResultsError, fn -> Garden.get_plan!(scope, plan.id) end
    end

    test "delete_plan/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      plan = plan_fixture(scope)
      assert_raise MatchError, fn -> Garden.delete_plan(other_scope, plan) end
    end

    test "change_plan/2 returns a plan changeset" do
      scope = user_scope_fixture()
      plan = plan_fixture(scope)
      assert %Ecto.Changeset{} = Garden.change_plan(scope, plan)
    end
  end
end
