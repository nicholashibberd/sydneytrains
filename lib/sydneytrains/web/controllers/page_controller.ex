defmodule Sydneytrains.Web.PageController do
  use Sydneytrains.Web, :controller

  alias Sydneytrains.Api
  alias Sydneytrains.Web.PageView

  def index(conn, _params) do
    render conn, "index.html"
  end
end
