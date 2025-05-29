defmodule Util.CsvParser do
  alias NimbleCSV.RFC4180, as: CSV

  def parse_rows(path, callback) do
    path
    |> File.stream!()
    |> CSV.parse_stream()
    |> Enum.reduce([], fn row, acc ->
      case apply(callback, [row]) do
        {:ok, _} -> acc
        {:error, _} -> [row | acc]
      end
    end)
  end
end
