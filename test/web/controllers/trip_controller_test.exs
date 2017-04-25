defmodule Sydneytrains.Web.TripControllerTest do
  use Sydneytrains.Web.ConnCase

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Trip

  @create_attrs %{block_id: "some block_id", direction_id: "some direction_id", route_id: "some route_id", service_id: "some service_id", shape_id: "some shape_id", trip_headsign: "some trip_headsign", trip_id: "some trip_id", trip_short_name: "some trip_short_name", wheelchair_accessible: "some wheelchair_accessible"}
  @update_attrs %{block_id: "some updated block_id", direction_id: "some updated direction_id", route_id: "some updated route_id", service_id: "some updated service_id", shape_id: "some updated shape_id", trip_headsign: "some updated trip_headsign", trip_id: "some updated trip_id", trip_short_name: "some updated trip_short_name", wheelchair_accessible: "some updated wheelchair_accessible"}
  @invalid_attrs %{block_id: nil, direction_id: nil, route_id: nil, service_id: nil, shape_id: nil, trip_headsign: nil, trip_id: nil, trip_short_name: nil, wheelchair_accessible: nil}

  def fixture(:trip) do
    {:ok, trip} = Api.create_trip(@create_attrs)
    trip
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, trip_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates trip and renders trip when data is valid", %{conn: conn} do
    conn = post conn, trip_path(conn, :create), trip: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, trip_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "block_id" => "some block_id",
      "direction_id" => "some direction_id",
      "route_id" => "some route_id",
      "service_id" => "some service_id",
      "shape_id" => "some shape_id",
      "trip_headsign" => "some trip_headsign",
      "trip_id" => "some trip_id",
      "trip_short_name" => "some trip_short_name",
      "wheelchair_accessible" => "some wheelchair_accessible"}
  end

  test "does not create trip and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, trip_path(conn, :create), trip: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen trip and renders trip when data is valid", %{conn: conn} do
    %Trip{id: id} = trip = fixture(:trip)
    conn = put conn, trip_path(conn, :update, trip), trip: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, trip_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "block_id" => "some updated block_id",
      "direction_id" => "some updated direction_id",
      "route_id" => "some updated route_id",
      "service_id" => "some updated service_id",
      "shape_id" => "some updated shape_id",
      "trip_headsign" => "some updated trip_headsign",
      "trip_id" => "some updated trip_id",
      "trip_short_name" => "some updated trip_short_name",
      "wheelchair_accessible" => "some updated wheelchair_accessible"}
  end

  test "does not update chosen trip and renders errors when data is invalid", %{conn: conn} do
    trip = fixture(:trip)
    conn = put conn, trip_path(conn, :update, trip), trip: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen trip", %{conn: conn} do
    trip = fixture(:trip)
    conn = delete conn, trip_path(conn, :delete, trip)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, trip_path(conn, :show, trip)
    end
  end
end
