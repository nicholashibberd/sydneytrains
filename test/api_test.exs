defmodule Sydneytrains.ApiTest do
  use Sydneytrains.DataCase

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Route

  @create_attrs %{agency_id: "some agency_id", route_color: "some route_color", route_desc: "some route_desc", route_id: "some route_id", route_long_name: "some route_long_name", route_short_name: "some route_short_name", route_text_color: "some route_text_color", route_type: "some route_type", route_url: "some route_url"}
  @update_attrs %{agency_id: "some updated agency_id", route_color: "some updated route_color", route_desc: "some updated route_desc", route_id: "some updated route_id", route_long_name: "some updated route_long_name", route_short_name: "some updated route_short_name", route_text_color: "some updated route_text_color", route_type: "some updated route_type", route_url: "some updated route_url"}
  @invalid_attrs %{agency_id: nil, route_color: nil, route_desc: nil, route_id: nil, route_long_name: nil, route_short_name: nil, route_text_color: nil, route_type: nil, route_url: nil}

  def fixture(:route, attrs \\ @create_attrs) do
    {:ok, route} = Api.create_route(attrs)
    route
  end

  test "get_route! returns the route with given id" do
    route = fixture(:route)
    assert Api.get_route!(route.id) == route
  end

  test "create_route/1 with valid data creates a route" do
    assert {:ok, %Route{} = route} = Api.create_route(@create_attrs)
    assert route.agency_id == "some agency_id"
    assert route.route_color == "some route_color"
    assert route.route_desc == "some route_desc"
    assert route.route_id == "some route_id"
    assert route.route_long_name == "some route_long_name"
    assert route.route_short_name == "some route_short_name"
    assert route.route_text_color == "some route_text_color"
    assert route.route_type == "some route_type"
    assert route.route_url == "some route_url"
  end

  test "create_route/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Api.create_route(@invalid_attrs)
  end

  test "update_route/2 with valid data updates the route" do
    route = fixture(:route)
    assert {:ok, route} = Api.update_route(route, @update_attrs)
    assert %Route{} = route
    assert route.agency_id == "some updated agency_id"
    assert route.route_color == "some updated route_color"
    assert route.route_desc == "some updated route_desc"
    assert route.route_id == "some updated route_id"
    assert route.route_long_name == "some updated route_long_name"
    assert route.route_short_name == "some updated route_short_name"
    assert route.route_text_color == "some updated route_text_color"
    assert route.route_type == "some updated route_type"
    assert route.route_url == "some updated route_url"
  end

  test "update_route/2 with invalid data returns error changeset" do
    route = fixture(:route)
    assert {:error, %Ecto.Changeset{}} = Api.update_route(route, @invalid_attrs)
    assert route == Api.get_route!(route.id)
  end

  test "delete_route/1 deletes the route" do
    route = fixture(:route)
    assert {:ok, %Route{}} = Api.delete_route(route)
    assert_raise Ecto.NoResultsError, fn -> Api.get_route!(route.id) end
  end

  test "change_route/1 returns a route changeset" do
    route = fixture(:route)
    assert %Ecto.Changeset{} = Api.change_route(route)
  end
end
