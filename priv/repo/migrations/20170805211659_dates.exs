defmodule Sydneytrains.Repo.Migrations.Dates do
  use Ecto.Migration

  def up do
    execute "CREATE MATERIALIZED VIEW dates as select date(date), to_char(date, 'day') AS day from generate_series(current_date, (select max(end_date) from api_services), '1 day') as date;"
  end

  def down do
    execute "DROP MATERIALIZED VIEW dates;"
  end
end
