defmodule Sydneytrains.Web.Router do
  use Sydneytrains.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Sydneytrains.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/routes", RouteController, except: [:new, :edit]
    resources "/stops", StopController, only: [:index, :show]
    resources "/trips", TripController, except: [:new, :edit]
    resources "/stop_times", StopTimeController, except: [:new, :edit]
    resources "/stations", StationController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Sydneytrains.Web do
  #   pipe_through :api
  # end
end
