defmodule Sydneytrains.Repo.Migrations.ServiceDates do
  use Ecto.Migration

  def up do
    execute "CREATE MATERIALIZED VIEW service_dates AS select date, service_id 
    from dates inner join api_services on (dates.date between
    api_services.start_date and api_services.end_date and case 
    extract(isodow from dates.date) when 1 then api_services.monday when 2 
    then api_services.tuesday when 3 then api_services.wednesday when 4 then 
    api_services.thursday when 5 then api_services.friday when 6 then 
    api_services.saturday when 7 then api_services.sunday end);"
  end

  def down do
    execute "DROP MATERIALZED VIEW service_dates;"
  end
end
