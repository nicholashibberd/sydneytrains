defmodule Sydneytrains.Repo.Migrations.CreateSydneytrains.Api.Stop do
  use Ecto.Migration

  def up do
    create table(:api_stops) do
      add :stop_id, :string
      add :stop_code, :string
      add :stop_name, :string
      add :stop_desc, :string
      add :stop_lat, :string
      add :stop_lon, :string
      add :zone_id, :string
      add :stop_url, :string
      add :location_type, :string
      add :parent_station, :string
      add :stop_timezone, :string
      add :wheelchair_boarding, :string

      timestamps()
    end

    execute "alter table api_stops alter column inserted_at set default now();"
    execute "alter table api_stops alter column updated_at set default now();"
    execute "\COPY api_stops(stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, stop_timezone, wheelchair_boarding) FROM '/var/lib/sydneytrains/stops.txt' DELIMITER ',' CSV HEADER;"
  end

  def down do
    drop table(:api_stops)
  end
end
