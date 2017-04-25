defmodule Sydneytrains.Web.StopTimeController do
  use Sydneytrains.Web, :controller

  alias Sydneytrains.Api
  alias Sydneytrains.Api.StopTime

  action_fallback Sydneytrains.Web.FallbackController

  def index(conn, _params) do
    stop_times = Api.list_stop_times()
    render(conn, "index.json", stop_times: stop_times)
  end

  def create(conn, %{"stop_time" => stop_time_params}) do
    with {:ok, %StopTime{} = stop_time} <- Api.create_stop_time(stop_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", stop_time_path(conn, :show, stop_time))
      |> render("show.json", stop_time: stop_time)
    end
  end

  def show(conn, %{"id" => id}) do
    stop_time = Api.get_stop_time!(id)
    render(conn, "show.json", stop_time: stop_time)
  end

  def update(conn, %{"id" => id, "stop_time" => stop_time_params}) do
    stop_time = Api.get_stop_time!(id)

    with {:ok, %StopTime{} = stop_time} <- Api.update_stop_time(stop_time, stop_time_params) do
      render(conn, "show.json", stop_time: stop_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    stop_time = Api.get_stop_time!(id)
    with {:ok, %StopTime{}} <- Api.delete_stop_time(stop_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
