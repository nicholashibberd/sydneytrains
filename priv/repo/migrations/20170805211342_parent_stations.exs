defmodule Sydneytrains.Repo.Migrations.ParentStations do
  use Ecto.Migration

  def up do
    execute "CREATE MATERIALIZED VIEW parent_stations AS select a.stop_id, v.name from api_stops a left outer join stations v on (a.parent_station = v.stop_id) where name is not NULL;"
  end

  def down do
    execute "DROP MATERIALIZED VIEW parent_stations;"
  end
end
