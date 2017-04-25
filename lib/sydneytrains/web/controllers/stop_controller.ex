defmodule Sydneytrains.Web.StopController do
  use Sydneytrains.Web, :controller

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Stop

  action_fallback Sydneytrains.Web.FallbackController

  def index(conn, _params) do
    stops = Api.list_stops()
    render(conn, "index.json", stops: stops)
  end

  def show(conn, %{"id" => id}) do
    stop = Api.get_stop!(id)
    render(conn, "show.json", stop: stop)
  end
end
