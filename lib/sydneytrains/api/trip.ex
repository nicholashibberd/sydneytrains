defmodule Sydneytrains.Api.Trip do
  use Ecto.Schema

  schema "api_trips" do
    field :block_id, :string
    field :direction_id, :string
    field :route_id, :string
    field :service_id, :string
    field :shape_id, :string
    field :trip_headsign, :string
    field :trip_id, :string
    field :trip_short_name, :string
    field :wheelchair_accessible, :string

    timestamps()
  end
end
