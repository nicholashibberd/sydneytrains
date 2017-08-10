defmodule Sydneytrains.Api.Station do
  use Ecto.Schema

  @primary_key {:stop_id, :string, []}
  schema "stations" do
    field :name, :string
    field :stop_lat, :string
    field :stop_lon, :string
    has_many :stops, Sydneytrains.Api.Stop, foreign_key: :parent_station
  end
end
