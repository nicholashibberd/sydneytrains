defmodule Sydneytrains.Api.TripDestination do
  use Ecto.Schema

  @derive {Poison.Encoder, only: [:last_stop, :departure_time]}
  @primary_key false
  schema "trip_destinations" do
    field :last_stop, :string
    field :departure_time, :string
    field :stop_id, :string
    field :date, :date
  end
end

