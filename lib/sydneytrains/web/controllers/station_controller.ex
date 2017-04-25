require IEx

defmodule Sydneytrains.Web.StationController do
  use Sydneytrains.Web, :controller

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Station

  action_fallback Sydneytrains.Web.FallbackController

  def index(conn, _params) do
    stations = Api.list_stations()
    render(conn, "index.json", stations: stations)
  end

  def show(conn, %{"id" => id}) do
    station = Api.get_station_with_stops(id)
    trips = Api.list_trips_by_station_and_date(station.stop_id, current_date)
    render(conn, "show.json", station: station, trips: trips)
  end

  defp current_date do
    {{y, m, d}, _} = :calendar.local_time
    {:ok, date} = Date.new(y, m, d)
    Date.to_string(date)
  end
end
