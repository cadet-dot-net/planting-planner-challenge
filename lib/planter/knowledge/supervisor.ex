defmodule Planter.Knowledge.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl Supervisor
  def init(_arg) do
    children = [Planter.Knowledge.Poller]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
