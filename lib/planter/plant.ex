defmodule Planter.Plant do
  @moduledoc """
  The Plant context.
  """

  import Ecto.Query, warn: false
  alias Planter.Repo

  alias Planter.Plant.Vegetable

  @doc """
  Returns the list of plants.

  ## Examples

      iex> list_plants()
      [%Vegetable{}, ...]

  """
  def list_plants do
    Repo.all(Vegetable)
  end

  @doc """
  Gets a single vegetable.

  Raises `Ecto.NoResultsError` if the Vegetable does not exist.

  ## Examples

      iex> get_vegetable!("onion")
      %Vegetable{}

      iex> get_vegetable!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vegetable!(name), do: Repo.get_by!(Vegetable, name: name)

  @doc """
  Creates a vegetable.

  ## Examples

      iex> create_vegetable(%{field: value})
      {:ok, %Vegetable{}}

      iex> create_vegetable(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vegetable(attrs) do
    %Vegetable{}
    |> Vegetable.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vegetable.

  ## Examples

      iex> update_vegetable(vegetable, %{field: new_value})
      {:ok, %Vegetable{}}

      iex> update_vegetable(vegetable, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vegetable(%Vegetable{} = vegetable, attrs) do
    vegetable
    |> Vegetable.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vegetable.

  ## Examples

      iex> delete_vegetable(vegetable)
      {:ok, %Vegetable{}}

      iex> delete_vegetable(vegetable)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vegetable(%Vegetable{} = vegetable) do
    Repo.delete(vegetable)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vegetable changes.

  ## Examples

      iex> change_vegetable(vegetable)
      %Ecto.Changeset{data: %Vegetable{}}

  """
  def change_vegetable(%Vegetable{} = vegetable, attrs \\ %{}) do
    Vegetable.changeset(vegetable, attrs)
  end
end
