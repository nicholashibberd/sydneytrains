defmodule Sydneytrains.Web.PlannerView do
  use Sydneytrains.Web, :view
  alias Sydneytrains.Web.ItineraryView

  def render("index.json", %{itineraries: itineraries}) do
    render_many(itineraries, ItineraryView, "itinerary.json")
  end
end
