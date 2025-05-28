defmodule Planter.Garden.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :area, :integer
    field :bed_id, :id
    field :plant_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plan, attrs, user_scope) do
    plan
    |> cast(attrs, [:area])
    |> validate_required([:area])
    |> put_change(:user_id, user_scope.user.id)
  end
end
