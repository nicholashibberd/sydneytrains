defmodule Sydneytrains.Web.StopTimeControllerTest do
  use Sydneytrains.Web.ConnCase

  alias Sydneytrains.Api
  alias Sydneytrains.Api.StopTime

  @create_attrs %{arrival_time: "some arrival_time", departure_time: "some departure_time", drop_off_type: "some drop_off_type", pickup_type: "some pickup_type", shape_dist_traveled: "some shape_dist_traveled", stop_headsign: "some stop_headsign", stop_id: "some stop_id", stop_sequence: "some stop_sequence", trip_id: "some trip_id"}
  @update_attrs %{arrival_time: "some updated arrival_time", departure_time: "some updated departure_time", drop_off_type: "some updated drop_off_type", pickup_type: "some updated pickup_type", shape_dist_traveled: "some updated shape_dist_traveled", stop_headsign: "some updated stop_headsign", stop_id: "some updated stop_id", stop_sequence: "some updated stop_sequence", trip_id: "some updated trip_id"}
  @invalid_attrs %{arrival_time: nil, departure_time: nil, drop_off_type: nil, pickup_type: nil, shape_dist_traveled: nil, stop_headsign: nil, stop_id: nil, stop_sequence: nil, trip_id: nil}

  def fixture(:stop_time) do
    {:ok, stop_time} = Api.create_stop_time(@create_attrs)
    stop_time
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, stop_time_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates stop_time and renders stop_time when data is valid", %{conn: conn} do
    conn = post conn, stop_time_path(conn, :create), stop_time: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, stop_time_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "arrival_time" => "some arrival_time",
      "departure_time" => "some departure_time",
      "drop_off_type" => "some drop_off_type",
      "pickup_type" => "some pickup_type",
      "shape_dist_traveled" => "some shape_dist_traveled",
      "stop_headsign" => "some stop_headsign",
      "stop_id" => "some stop_id",
      "stop_sequence" => "some stop_sequence",
      "trip_id" => "some trip_id"}
  end

  test "does not create stop_time and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, stop_time_path(conn, :create), stop_time: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen stop_time and renders stop_time when data is valid", %{conn: conn} do
    %StopTime{id: id} = stop_time = fixture(:stop_time)
    conn = put conn, stop_time_path(conn, :update, stop_time), stop_time: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, stop_time_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "arrival_time" => "some updated arrival_time",
      "departure_time" => "some updated departure_time",
      "drop_off_type" => "some updated drop_off_type",
      "pickup_type" => "some updated pickup_type",
      "shape_dist_traveled" => "some updated shape_dist_traveled",
      "stop_headsign" => "some updated stop_headsign",
      "stop_id" => "some updated stop_id",
      "stop_sequence" => "some updated stop_sequence",
      "trip_id" => "some updated trip_id"}
  end

  test "does not update chosen stop_time and renders errors when data is invalid", %{conn: conn} do
    stop_time = fixture(:stop_time)
    conn = put conn, stop_time_path(conn, :update, stop_time), stop_time: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen stop_time", %{conn: conn} do
    stop_time = fixture(:stop_time)
    conn = delete conn, stop_time_path(conn, :delete, stop_time)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, stop_time_path(conn, :show, stop_time)
    end
  end
end
