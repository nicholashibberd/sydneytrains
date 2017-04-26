defmodule Sydneytrains.Web.StationView do
  use Sydneytrains.Web, :view
  alias Sydneytrains.Web.StationView
  alias Sydneytrains.Api.Station

  def render("index.json", %{stations: stations}) do
    render_many(stations, StationView, "station.json")
  end

  def render("show.json", %{station: station, trips: trips}) do
    %{name: station.name,
      trips: trips
    }
  end

  def render("station.json", %{station: station}) do
    %{name: station.name,
      stop_id: station.stop_id}
  end
end
