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
  end

  def down do
    drop table(:api_stop_times)
  end
end
