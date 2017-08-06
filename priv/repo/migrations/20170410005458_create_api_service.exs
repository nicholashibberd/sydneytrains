defmodule Sydneytrains.Repo.Migrations.CreateSydneytrains.Api.Service do
  use Ecto.Migration

  def up do
    create table(:api_services) do
      add :service_id, :string
      add :monday, :boolean, default: false, null: false
      add :tuesday, :boolean, default: false, null: false
      add :wednesday, :boolean, default: false, null: false
      add :thursday, :boolean, default: false, null: false
      add :friday, :boolean, default: false, null: false
      add :saturday, :boolean, default: false, null: false
      add :sunday, :boolean, default: false, null: false
      add :start_date, :date
      add :end_date, :date

      timestamps()
    end

    execute "alter table api_services alter column inserted_at set default now();"
    execute "alter table api_services alter column updated_at set default now();"
    execute "\COPY api_services(service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date) FROM '/var/lib/sydneytrains/calendar.txt' DELIMITER ',' CSV HEADER;"
  end

  def down do
    drop table(:api_services)
  end
end
