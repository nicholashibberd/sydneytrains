defmodule Sydneytrains.Repo.Migrations.LastStops do
  use Ecto.Migration

  def up do
    execute "CREATE MATERIALIZED VIEW last_stops as select distinct trip_id, 
    first_value(stop_id) over (w) as stop_id, first_value(arrival_time) over (w)
    as arrival_time from api_stop_times window w as (partition by trip_id order 
    by arrival_time desc);"
  end

  def down do
    execute "DROP MATERIALIZED VIEW last_stops;"
  end
end
