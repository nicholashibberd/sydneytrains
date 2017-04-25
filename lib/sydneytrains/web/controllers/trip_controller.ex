defmodule Sydneytrains.Web.TripController do
  use Sydneytrains.Web, :controller

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Trip

  action_fallback Sydneytrains.Web.FallbackController

  def index(conn, _params) do
    trips = Api.list_trips()
    render(conn, "index.json", trips: trips)
  end

  def create(conn, %{"trip" => trip_params}) do
    with {:ok, %Trip{} = trip} <- Api.create_trip(trip_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", trip_path(conn, :show, trip))
      |> render("show.json", trip: trip)
    end
  end

  def show(conn, %{"id" => id}) do
    trip = Api.get_trip!(id)
    render(conn, "show.json", trip: trip)
  end

  def update(conn, %{"id" => id, "trip" => trip_params}) do
    trip = Api.get_trip!(id)

    with {:ok, %Trip{} = trip} <- Api.update_trip(trip, trip_params) do
      render(conn, "show.json", trip: trip)
    end
  end

  def delete(conn, %{"id" => id}) do
    trip = Api.get_trip!(id)
    with {:ok, %Trip{}} <- Api.delete_trip(trip) do
      send_resp(conn, :no_content, "")
    end
  end
end
