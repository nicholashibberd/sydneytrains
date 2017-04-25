defmodule Sydneytrains.Web.StopView do
  use Sydneytrains.Web, :view
  alias Sydneytrains.Web.StopView

  def render("index.json", %{stops: stops}) do
    %{data: render_many(stops, StopView, "stop.json")}
  end

  def render("show.json", %{stop: stop}) do
    %{data: render_one(stop, StopView, "stop.json")}
  end

  def render("stop.json", %{stop: stop}) do
    %{id: stop.id,
      stop_id: stop.stop_id,
      stop_code: stop.stop_code,
      stop_name: stop.stop_name,
      stop_desc: stop.stop_desc,
      stop_lat: stop.stop_lat,
      stop_lon: stop.stop_lon,
      zone_id: stop.zone_id,
      stop_url: stop.stop_url,
      location_type: stop.location_type,
      parent_station: stop.parent_station,
      stop_timezone: stop.stop_timezone,
      wheelchair_boarding: stop.wheelchair_boarding}
  end
end
