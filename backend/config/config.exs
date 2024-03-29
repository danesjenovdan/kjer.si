# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kjer_si,
  ecto_repos: [KjerSi.Repo],
  generators: [binary_id: true]

# Add support for microseconds at the DB level
# this avoids having to configure it on every migration file
config :kjer_si, KjerSi.Repo, migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :kjer_si, KjerSiWeb.Endpoint,
  url: [host: System.get_env("HOST")],
  secret_key_base: System.get_env("SECRET_KEY"),
  render_errors: [view: KjerSiWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: KjerSi.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
