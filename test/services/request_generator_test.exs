defmodule Sydneytrains.Services.RequestGeneratorTest do
  use ExUnit.Case

  alias Sydneytrains.Services.RequestGenerator
  alias Sydneytrains.Api.Station
  alias Sydneytrains.Api.Stop

  test "creates a request URL" do
    from = %Station{stop_lat: -33.9661295363, stop_lon: 151.089386527}
    to = %Station{stop_lat: -33.8912022841, stop_lon: 151.2483843}
    url = "http://localhost:8082/otp/routers/default/plan?date=2017-08-08&fromPlace=-33.9661295363%2C151.089386527&mode=RAIL&time=4%3A20pm&toPlace=-33.8912022841%2C151.2483843"
    assert RequestGenerator.generate(from, to, "2017-08-08", "4:20pm") == url
  end
end
