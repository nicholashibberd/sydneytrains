defmodule Sydneytrains.Web.TripView do
  use Sydneytrains.Web, :view
  alias Sydneytrains.Web.TripView

  def render("index.json", %{trips: trips}) do
    %{data: render_many(trips, TripView, "trip.json")}
  end

  def render("show.json", %{trip: trip}) do
    %{data: render_one(trip, TripView, "trip.json")}
  end

  def render("trip.json", %{trip: trip}) do
    %{id: trip.id,
      route_id: trip.route_id,
      service_id: trip.service_id,
      trip_id: trip.trip_id,
      trip_headsign: trip.trip_headsign,
      trip_short_name: trip.trip_short_name,
      direction_id: trip.direction_id,
      block_id: trip.block_id,
      shape_id: trip.shape_id,
      wheelchair_accessible: trip.wheelchair_accessible}
  end
end
