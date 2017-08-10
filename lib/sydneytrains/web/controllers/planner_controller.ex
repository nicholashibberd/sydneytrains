defmodule Sydneytrains.Web.PlannerController do
  use Sydneytrains.Web, :controller

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Planner

  action_fallback Sydneytrains.Web.FallbackController

  def index(conn, params) do
    itineraries = Api.plan(params)
    render(conn, "index.json", itineraries: itineraries)
  end
end
