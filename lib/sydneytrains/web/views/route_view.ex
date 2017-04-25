defmodule Sydneytrains.Web.RouteView do
  use Sydneytrains.Web, :view
  alias Sydneytrains.Web.RouteView

  def render("index.json", %{routes: routes}) do
    %{data: render_many(routes, RouteView, "route.json")}
  end

  def render("show.json", %{route: route}) do
    %{data: render_one(route, RouteView, "route.json")}
  end

  def render("route.json", %{route: route}) do
    %{id: route.id,
      route_id: route.route_id,
      agency_id: route.agency_id,
      route_short_name: route.route_short_name,
      route_long_name: route.route_long_name,
      route_desc: route.route_desc,
      route_type: route.route_type,
      route_url: route.route_url,
      route_color: route.route_color,
      route_text_color: route.route_text_color}
  end
end
