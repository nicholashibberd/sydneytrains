# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sydneytrains,
  ecto_repos: [Sydneytrains.Repo]

# Configures the endpoint
config :sydneytrains, Sydneytrains.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wOY4F4OS/YX3kKQQ+DV3MZ2dIlKX3HM6QeEDL3Y+7fDaYiAlhzlSvqTzWO8gt9bH",
  render_errors: [view: Sydneytrains.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sydneytrains.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
