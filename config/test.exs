use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sydneytrains, Sydneytrains.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sydneytrains, Sydneytrains.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "sydneytrains",
  password: "password",
  database: "sydneytrains_test",
  hostname: "localhost",
  port: 5433,
  pool: Ecto.Adapters.SQL.Sandbox
