defmodule Sydneytrains.Api.Planner do
  alias Sydneytrains.Api
  alias Sydneytrains.Services.RequestGenerator
  alias Sydneytrains.Services.ResponseParser

  def plan(%{"from" => from, "to" => to, "date" => date, "time" => time}) do
    from = Api.get_station_with_stops(from)
    from_stops = get_stops(from)
    to = Api.get_station_with_stops(to)
    to_stops = get_stops(to)
    url = RequestGenerator.generate(from, to, date, time)
    %{body: response} = HTTPotion.get(url)
    ResponseParser.parse(response, to_stops)
  end

  defp get_stops(station), do: Enum.map(station.stops, &(&1.stop_code))
end
