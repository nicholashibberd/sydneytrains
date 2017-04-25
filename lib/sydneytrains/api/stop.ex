defmodule Sydneytrains.Api.Stop do
  use Ecto.Schema

  schema "api_stops" do
    field :location_type, :string
    field :stop_code, :string
    field :stop_desc, :string
    field :stop_id, :string
    field :stop_lat, :string
    field :stop_lon, :string
    field :stop_name, :string
    field :stop_timezone, :string
    field :stop_url, :string
    field :wheelchair_boarding, :string
    field :zone_id, :string
    belongs_to :station, Sydneytrains.Api.Station, foreign_key: :parent_station, type: :string

    timestamps()
  end
end
