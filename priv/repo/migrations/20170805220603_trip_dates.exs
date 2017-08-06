defmodule Sydneytrains.Repo.Migrations.TripDates do
  use Ecto.Migration

  def up do
    execute "CREATE MATERIALIZED VIEW trip_dates AS select date, trip_id from service_dates inner join api_trips on (service_dates.service_id = api_trips.service_id) order by date;"
  end

  def down do
    execute "DROP MATERIALIZED VIEW trip_dates;"
  end
end
