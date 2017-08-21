defmodule Sydneytrains.Web.PageView do
  use Sydneytrains.Web, :view

  alias Sydneytrains.Web.StationView
  alias Sydneytrains.Api

  def all_stations_json do
    Api.list_stations |> render_many(StationView, "station.json") |> Poison.encode! |> raw
  end
end
