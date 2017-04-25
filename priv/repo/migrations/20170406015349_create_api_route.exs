defmodule Sydneytrains.Repo.Migrations.CreateSydneytrains.Api.Route do
  use Ecto.Migration

  def up do
    create table(:api_routes) do
      add :route_id, :string
      add :agency_id, :string
      add :route_short_name, :string
      add :route_long_name, :string
      add :route_desc, :string
      add :route_type, :string
      add :route_url, :string
      add :route_color, :string
      add :route_text_color, :string

      timestamps()
    end

    execute "alter table api_routes alter column inserted_at set default now();"
    execute "alter table api_routes alter column updated_at set default now();"
  end

  def down do
    drop table(:api_routes)
  end
end
