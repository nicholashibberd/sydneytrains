defmodule Sydneytrains.Web.StopControllerTest do
  use Sydneytrains.Web.ConnCase

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Stop

  @create_attrs %{location_type: "some location_type", parent_station: "some parent_station", stop_code: "some stop_code", stop_desc: "some stop_desc", stop_id: "some stop_id", stop_lat: "some stop_lat", stop_lon: "some stop_lon", stop_name: "some stop_name", stop_timezone: "some stop_timezone", stop_url: "some stop_url", wheelchair_boarding: "some wheelchair_boarding", zone_id: "some zone_id"}
  @update_attrs %{location_type: "some updated location_type", parent_station: "some updated parent_station", stop_code: "some updated stop_code", stop_desc: "some updated stop_desc", stop_id: "some updated stop_id", stop_lat: "some updated stop_lat", stop_lon: "some updated stop_lon", stop_name: "some updated stop_name", stop_timezone: "some updated stop_timezone", stop_url: "some updated stop_url", wheelchair_boarding: "some updated wheelchair_boarding", zone_id: "some updated zone_id"}
  @invalid_attrs %{location_type: nil, parent_station: nil, stop_code: nil, stop_desc: nil, stop_id: nil, stop_lat: nil, stop_lon: nil, stop_name: nil, stop_timezone: nil, stop_url: nil, wheelchair_boarding: nil, zone_id: nil}

  def fixture(:stop) do
    {:ok, stop} = Api.create_stop(@create_attrs)
    stop
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, stop_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates stop and renders stop when data is valid", %{conn: conn} do
    conn = post conn, stop_path(conn, :create), stop: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, stop_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "location_type" => "some location_type",
      "parent_station" => "some parent_station",
      "stop_code" => "some stop_code",
      "stop_desc" => "some stop_desc",
      "stop_id" => "some stop_id",
      "stop_lat" => "some stop_lat",
      "stop_lon" => "some stop_lon",
      "stop_name" => "some stop_name",
      "stop_timezone" => "some stop_timezone",
      "stop_url" => "some stop_url",
      "wheelchair_boarding" => "some wheelchair_boarding",
      "zone_id" => "some zone_id"}
  end

  test "does not create stop and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, stop_path(conn, :create), stop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen stop and renders stop when data is valid", %{conn: conn} do
    %Stop{id: id} = stop = fixture(:stop)
    conn = put conn, stop_path(conn, :update, stop), stop: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, stop_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "location_type" => "some updated location_type",
      "parent_station" => "some updated parent_station",
      "stop_code" => "some updated stop_code",
      "stop_desc" => "some updated stop_desc",
      "stop_id" => "some updated stop_id",
      "stop_lat" => "some updated stop_lat",
      "stop_lon" => "some updated stop_lon",
      "stop_name" => "some updated stop_name",
      "stop_timezone" => "some updated stop_timezone",
      "stop_url" => "some updated stop_url",
      "wheelchair_boarding" => "some updated wheelchair_boarding",
      "zone_id" => "some updated zone_id"}
  end

  test "does not update chosen stop and renders errors when data is invalid", %{conn: conn} do
    stop = fixture(:stop)
    conn = put conn, stop_path(conn, :update, stop), stop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen stop", %{conn: conn} do
    stop = fixture(:stop)
    conn = delete conn, stop_path(conn, :delete, stop)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, stop_path(conn, :show, stop)
    end
  end
end
