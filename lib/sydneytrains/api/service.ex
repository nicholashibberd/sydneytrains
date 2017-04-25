defmodule Sydneytrains.Api.Service do
  use Ecto.Schema

  schema "api_services" do
    field :end_date, :date
    field :friday, :boolean, default: false
    field :monday, :boolean, default: false
    field :saturday, :boolean, default: false
    field :service_id, :string
    field :start_date, :date
    field :sunday, :boolean, default: false
    field :thursday, :boolean, default: false
    field :tuesday, :boolean, default: false
    field :wednesday, :boolean, default: false

    timestamps()
  end
end
