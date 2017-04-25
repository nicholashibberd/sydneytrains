defmodule Sydneytrains.Api.Route do
  use Ecto.Schema

  schema "api_routes" do
    field :agency_id, :string
    field :route_color, :string
    field :route_desc, :string
    field :route_id, :string
    field :route_long_name, :string
    field :route_short_name, :string
    field :route_text_color, :string
    field :route_type, :string
    field :route_url, :string

    timestamps()
  end
end
