defmodule Sydneytrains.Api.StopTime do
  use Ecto.Schema

  schema "api_stop_times" do
    field :arrival_time, :string
    field :departure_time, :string
    field :drop_off_type, :string
    field :pickup_type, :string
    field :shape_dist_traveled, :string
    field :stop_headsign, :string
    field :stop_id, :string
    field :stop_sequence, :string
    field :trip_id, :string

    timestamps()
  end
end
