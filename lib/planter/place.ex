defmodule Planter.Place do
  @moduledoc """
  The Place context.
  """

  import Ecto.Query, warn: false
  alias Planter.Repo

  alias Planter.Place.Bed

  @doc """
  Returns the list of beds.

  ## Examples

      iex> list_beds()
      [%Bed{}, ...]

  """
  def list_beds do
    Repo.all(Bed)
  end

  @doc """
  Gets a single bed.

  Raises `Ecto.NoResultsError` if the Bed does not exist.

  ## Examples

      iex> get_bed!(123)
      %Bed{}

      iex> get_bed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bed!(id), do: Repo.get!(Bed, id)

  @doc """
  Creates a bed.

  ## Examples

      iex> create_bed(%{field: value})
      {:ok, %Bed{}}

      iex> create_bed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bed(attrs) do
    %Bed{}
    |> Bed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bed.

  ## Examples

      iex> update_bed(bed, %{field: new_value})
      {:ok, %Bed{}}

      iex> update_bed(bed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bed(%Bed{} = bed, attrs) do
    bed
    |> Bed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bed.

  ## Examples

      iex> delete_bed(bed)
      {:ok, %Bed{}}

      iex> delete_bed(bed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bed(%Bed{} = bed) do
    Repo.delete(bed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bed changes.

  ## Examples

      iex> change_bed(bed)
      %Ecto.Changeset{data: %Bed{}}

  """
  def change_bed(%Bed{} = bed, attrs \\ %{}) do
    Bed.changeset(bed, attrs)
  end
end
