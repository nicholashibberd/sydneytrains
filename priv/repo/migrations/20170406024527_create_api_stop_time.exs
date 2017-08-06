defmodule Sydneytrains.Repo.Migrations.CreateSydneytrains.Api.StopTime do
  use Ecto.Migration

  def up do
    create table(:api_stop_times) do
      add :trip_id, :string
      add :arrival_time, :string
      add :departure_time, :string
      add :stop_id, :string
      add :stop_sequence, :string
      add :stop_headsign, :string
      add :pickup_type, :string
      add :drop_off_type, :string
      add :shape_dist_traveled, :string

      timestamps()
    end

    execute "alter table api_stop_times alter column inserted_at set default now();"
    execute "alter table api_stop_times alter column updated_at set default now();"
    execute "\COPY api_stop_times(trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type,shape_dist_traveled) FROM '/var/lib/sydneytrains/stop_times.txt' DELIMITER ',' CSV HEADER;"
  end

  def down do
    drop table(:api_stop_times)
  end
end
