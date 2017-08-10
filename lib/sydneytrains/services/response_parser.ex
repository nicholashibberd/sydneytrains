defmodule Sydneytrains.Services.ResponseParser do
  alias Sydneytrains.DateUtils

  def parse(response, to_stops) do
    %{"plan" => %{"itineraries" => itineraries}} = Poison.Parser.parse!(response)
    Enum.map(itineraries, fn i -> itinerary(i, to_stops) end)
  end

  defp itinerary(itin, to_stops) do
    %{
      legs: itin["legs"] |> rail_legs(to_stops, []) |> Enum.map(&leg/1)
    }
  end

  defp rail_legs([], _, _), do: raise ArgumentError
  defp rail_legs([h | t], to_stops, acc) do
    if Enum.any?(to_stops, &(&1 == h["to"]["stopCode"])) do
       Enum.reverse([h | acc])
    else
      rail_legs(t, to_stops, [h | acc])
    end
  end

  defp leg(lg) do
    %{
      from: from_station(lg["from"]),
      to: to_station(lg["to"])
    }
  end

  defp from_station(st) do
    %{
      name: st["name"],
      time: div(st["departure"], 1000)
    }
  end

  defp to_station(st) do
    %{
      name: st["name"],
      time: div(st["arrival"], 1000)
    }
  end
end
