defmodule Planter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlanterWeb.Telemetry,
      Planter.Repo,
      {DNSCluster, query: Application.get_env(:planter, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Planter.PubSub},
      # Start a worker by calling: Planter.Worker.start_link(arg)
      # {Planter.Worker, arg},
      # Start to serve requests, typically the last entry
      PlanterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Planter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlanterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
