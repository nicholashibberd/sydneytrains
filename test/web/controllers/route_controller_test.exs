defmodule Sydneytrains.Web.RouteControllerTest do
  use Sydneytrains.Web.ConnCase

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Route

  @create_attrs %{agency_id: "some agency_id", route_color: "some route_color", route_desc: "some route_desc", route_id: "some route_id", route_long_name: "some route_long_name", route_short_name: "some route_short_name", route_text_color: "some route_text_color", route_type: "some route_type", route_url: "some route_url"}
  @update_attrs %{agency_id: "some updated agency_id", route_color: "some updated route_color", route_desc: "some updated route_desc", route_id: "some updated route_id", route_long_name: "some updated route_long_name", route_short_name: "some updated route_short_name", route_text_color: "some updated route_text_color", route_type: "some updated route_type", route_url: "some updated route_url"}
  @invalid_attrs %{agency_id: nil, route_color: nil, route_desc: nil, route_id: nil, route_long_name: nil, route_short_name: nil, route_text_color: nil, route_type: nil, route_url: nil}

  def fixture(:route) do
    {:ok, route} = Api.create_route(@create_attrs)
    route
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, route_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates route and renders route when data is valid", %{conn: conn} do
    conn = post conn, route_path(conn, :create), route: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, route_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "agency_id" => "some agency_id",
      "route_color" => "some route_color",
      "route_desc" => "some route_desc",
      "route_id" => "some route_id",
      "route_long_name" => "some route_long_name",
      "route_short_name" => "some route_short_name",
      "route_text_color" => "some route_text_color",
      "route_type" => "some route_type",
      "route_url" => "some route_url"}
  end

  test "does not create route and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, route_path(conn, :create), route: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen route and renders route when data is valid", %{conn: conn} do
    %Route{id: id} = route = fixture(:route)
    conn = put conn, route_path(conn, :update, route), route: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, route_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "agency_id" => "some updated agency_id",
      "route_color" => "some updated route_color",
      "route_desc" => "some updated route_desc",
      "route_id" => "some updated route_id",
      "route_long_name" => "some updated route_long_name",
      "route_short_name" => "some updated route_short_name",
      "route_text_color" => "some updated route_text_color",
      "route_type" => "some updated route_type",
      "route_url" => "some updated route_url"}
  end

  test "does not update chosen route and renders errors when data is invalid", %{conn: conn} do
    route = fixture(:route)
    conn = put conn, route_path(conn, :update, route), route: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen route", %{conn: conn} do
    route = fixture(:route)
    conn = delete conn, route_path(conn, :delete, route)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, route_path(conn, :show, route)
    end
  end
end
