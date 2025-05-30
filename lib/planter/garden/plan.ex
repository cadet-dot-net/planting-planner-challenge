defmodule Planter.Garden.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :area, :float
    field :bed_id, :id
    field :plant_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plan, attrs, user_scope) do
    plan
    |> cast(attrs, [:area, :bed_id, :plant_id])
    |> validate_required([:area, :bed_id])
    |> put_change(:user_id, user_scope.user.id)
  end
end
