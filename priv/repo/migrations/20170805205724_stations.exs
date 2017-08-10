defmodule Sydneytrains.Repo.Migrations.Stations do
  use Ecto.Migration

  def up do
    execute "CREATE MATERIALIZED VIEW stations AS SELECT stop_id, replace(stop_name, ' Station', '') as name, stop_lat, stop_lon from api_stops where parent_station = '' order by stop_name;"
  end

  def down do
    execute "DROP MATERIALIZED VIEW stations;"
  end
end
