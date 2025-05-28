defmodule Planter.Garden do
  @moduledoc """
  The Garden context.
  """

  import Ecto.Query, warn: false
  alias Planter.Repo

  alias Planter.Garden.Plan
  alias Planter.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any plan changes.

  The broadcasted messages match the pattern:

    * {:created, %Plan{}}
    * {:updated, %Plan{}}
    * {:deleted, %Plan{}}

  """
  def subscribe_plans(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Planter.PubSub, "user:#{key}:plans")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Planter.PubSub, "user:#{key}:plans", message)
  end

  @doc """
  Returns the list of plans.

  ## Examples

      iex> list_plans(scope)
      [%Plan{}, ...]

  """
  def list_plans(%Scope{} = scope) do
    (from plan in Plan, where: plan.user_id == ^scope.user.id)
    |> Repo.all()
    |> Repo.preload([:bed, :plant])
  end

  @doc """
  Gets a single plan.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

      iex> get_plan!(123)
      %Plan{}

      iex> get_plan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plan!(%Scope{} = scope, id) do
    Repo.get_by!(Plan, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a plan.

  ## Examples

      iex> create_plan(%{field: value})
      {:ok, %Plan{}}

      iex> create_plan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plan(%Scope{} = scope, attrs) do
    with {:ok, plan = %Plan{}} <-
           %Plan{}
           |> Plan.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, plan})
      {:ok, plan}
    end
  end

  @doc """
  Updates a plan.

  ## Examples

      iex> update_plan(plan, %{field: new_value})
      {:ok, %Plan{}}

      iex> update_plan(plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_plan(%Scope{} = scope, %Plan{} = plan, attrs) do
    true = plan.user_id == scope.user.id

    with {:ok, plan = %Plan{}} <-
           plan
           |> Plan.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, plan})
      {:ok, plan}
    end
  end

  @doc """
  Deletes a plan.

  ## Examples

      iex> delete_plan(plan)
      {:ok, %Plan{}}

      iex> delete_plan(plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_plan(%Scope{} = scope, %Plan{} = plan) do
    true = plan.user_id == scope.user.id

    with {:ok, plan = %Plan{}} <-
           Repo.delete(plan) do
      broadcast(scope, {:deleted, plan})
      {:ok, plan}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking plan changes.

  ## Examples

      iex> change_plan(plan)
      %Ecto.Changeset{data: %Plan{}}

  """
  def change_plan(%Scope{} = scope, %Plan{} = plan, attrs \\ %{}) do
    true = plan.user_id == scope.user.id

    Plan.changeset(plan, attrs, scope)
  end
end
