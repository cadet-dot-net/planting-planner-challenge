defmodule Planter.Knowledge.Poller do
    @moduledoc """
  Server to periodically read the background knowledge JSON
  file and pass the data to the Knowledge module
  """

  require Logger
  use GenServer, restart: :temporary

  @table_name :knowledge
  @poll_time_ms 60_000
  @knowledge_path "priv/static/data/background-knowledge.json"

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def poll() do
    GenServer.call(__MODULE__, :poll_safely)
  end

  def status() do
    GenServer.call(__MODULE__, :status)
  end

  @impl GenServer
  def init(_args) do
    bootstrap_knowledge_table()
    periodic_poll()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call(:poll_safely, _from, state) do
    poll_safely()
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call(:status, _from, state) do
    {:reply, "i'm good!", state}
  end

  @impl GenServer
  def handle_info(:poll, state) do
    periodic_poll()
    {:noreply, state}
  end

  defp bootstrap_knowledge_table() do
    :ets.new(@table_name, [:named_table, :set, :public, read_concurrency: true])
  end

  defp periodic_poll() do
    poll_safely()
    Process.send_after(self(), :poll, @poll_time_ms)
  end

  defp poll_safely() do
    case File.read(@knowledge_path) do
      {:ok, contents} ->
        cache(contents)
        Planter.Knowledge.store_plants()

      {:error, reason} -> Logger.error("Failed to read background knowledge: #{reason}")
    end
  end

  defp cache(contents) do
    case JSON.decode(contents) do
      {:ok, data} ->
        data
        |> Enum.group_by(&Map.get(&1, "name"), &Map.delete(&1, "name"))
        |> Enum.map(&normalise_knowledge_item/1)
        |> then(&:ets.insert_new(@table_name, &1))

      {:error, reason} ->
        Logger.error("Failed to decode background knowledge: #{reason}")
    end
  end

  defp normalise_knowledge_item({name, attrs}) do
    [attrs] = attrs

    {
      name,
      Map.new(attrs, fn {k, v} ->
        {String.to_atom(k), v}
      end)
    }
  end
end
