defmodule Sydneytrains.Services.RequestGenerator do
  @host "http://localhost"
  @port "8082"
  @endpoint "/otp/routers/default/plan"

  def generate(from, to, date, time) do
    params = %{
      date: date,
      fromPlace: "#{from.stop_lat},#{from.stop_lon}",
      mode: "RAIL",
      time: time,
      toPlace: "#{to.stop_lat},#{to.stop_lon}",
    }
    @host <> ":" <> @port <> @endpoint <> "?" <> URI.encode_query(params)
  end
end
