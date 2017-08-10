defmodule Sydneytrains.Web.ItineraryView do
  use Sydneytrains.Web, :view
  alias Sydneytrains.Web.ItineraryView

  def render("itinerary.json", %{itinerary: itinerary}) do
    itinerary
  end
end
