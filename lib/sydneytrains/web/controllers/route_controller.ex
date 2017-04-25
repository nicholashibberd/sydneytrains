defmodule Sydneytrains.Web.RouteController do
  use Sydneytrains.Web, :controller

  alias Sydneytrains.Api
  alias Sydneytrains.Api.Route

  action_fallback Sydneytrains.Web.FallbackController

  def index(conn, _params) do
    routes = Api.list_routes()
    render(conn, "index.json", routes: routes)
  end

  def create(conn, %{"route" => route_params}) do
    with {:ok, %Route{} = route} <- Api.create_route(route_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", route_path(conn, :show, route))
      |> render("show.json", route: route)
    end
  end

  def show(conn, %{"id" => id}) do
    route = Api.get_route!(id)
    render(conn, "show.json", route: route)
  end

  def update(conn, %{"id" => id, "route" => route_params}) do
    route = Api.get_route!(id)

    with {:ok, %Route{} = route} <- Api.update_route(route, route_params) do
      render(conn, "show.json", route: route)
    end
  end

  def delete(conn, %{"id" => id}) do
    route = Api.get_route!(id)
    with {:ok, %Route{}} <- Api.delete_route(route) do
      send_resp(conn, :no_content, "")
    end
  end
end
