defmodule Sydneytrains.Repo.Migrations.TripDestinations do
  use Ecto.Migration

  def up do
    execute "CREATE MATERIALIZED VIEW trip_destinations as select last_stop, 
    departure_time, st.stop_id, td.date, case 
    substring(departure_time, '.{2}')::integer >= 24 when true then (date + 
    integer '1' || ' ' || substring(departure_time, '.{2}')::integer - 24 || 
    substring(departure_time, '.{6}$'))::timestamp else (date || ' ' || 
    departure_time)::timestamp end as departure_datetime from api_stop_times st
    inner join trip_dates td on (st.trip_id = td.trip_id) inner join trips t on 
    (st.trip_id = t.trip_id);"
  end

  def down do
    execute "DROP MATERIALIZED VIEW trip_destinations;"
  end
end
