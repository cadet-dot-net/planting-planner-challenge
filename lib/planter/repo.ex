defmodule Planter.Repo do
  use Ecto.Repo,
    otp_app: :planter,
    adapter: Ecto.Adapters.Postgres
end
