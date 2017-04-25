defmodule Sydneytrains.Web.StopTimeView do
  use Sydneytrains.Web, :view
  alias Sydneytrains.Web.StopTimeView

  def render("index.json", %{stop_times: stop_times}) do
    %{data: render_many(stop_times, StopTimeView, "stop_time.json")}
  end

  def render("show.json", %{stop_time: stop_time}) do
    %{data: render_one(stop_time, StopTimeView, "stop_time.json")}
  end

  def render("stop_time.json", %{stop_time: stop_time}) do
    %{id: stop_time.id,
      trip_id: stop_time.trip_id,
      arrival_time: stop_time.arrival_time,
      departure_time: stop_time.departure_time,
      stop_id: stop_time.stop_id,
      stop_sequence: stop_time.stop_sequence,
      stop_headsign: stop_time.stop_headsign,
      pickup_type: stop_time.pickup_type,
      drop_off_type: stop_time.drop_off_type,
      shape_dist_traveled: stop_time.shape_dist_traveled}
  end
end
