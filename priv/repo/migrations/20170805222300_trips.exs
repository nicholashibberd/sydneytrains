defmodule Sydneytrains.Repo.Migrations.Trips do
  use Ecto.Migration

  def up do
    execute "CREATE MATERIALIZED VIEW trips AS select t.*, name as last_stop 
    from api_trips t inner join last_stops l on t.trip_id = l.trip_id inner join 
    parent_stations s on (l.stop_id = s.stop_id);"
  end

  def down do
    execute "DROP MATERIALIZED VIEW trips;"
  end
end
