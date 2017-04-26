defmodule Sydneytrains.Web.StationController do
  use Sydneytrains.Web, :controller
  import Sydneytrains.DateUtils

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Station

  action_fallback Sydneytrains.Web.FallbackController

  def index(conn, _params) do
    stations = Api.list_stations()
    render(conn, "index.json", stations: stations)
  end

  def show(conn, %{"id" => id}) do
    station = Api.get_station_with_stops(id)
    stop_ids = station.stops |> Enum.map(&(&1.stop_id))
    trips = Api.list_trips_by_station_and_date(stop_ids, current_date)
    render(conn, "show.json", station: station, trips: trips)
  end
end
