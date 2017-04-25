defmodule Sydneytrains.Repo.Migrations.CreateSydneytrains.Api.Trip do
  use Ecto.Migration

  def up do
    create table(:api_trips) do
      add :route_id, :string
      add :service_id, :string
      add :trip_id, :string
      add :trip_headsign, :string
      add :trip_short_name, :string
      add :direction_id, :string
      add :block_id, :string
      add :shape_id, :string
      add :wheelchair_accessible, :string

      timestamps()
    end

    execute "alter table api_trips alter column inserted_at set default now();"
    execute "alter table api_trips alter column updated_at set default now();"
  end

  def down do
    drop table(:api_trips)
  end
end
