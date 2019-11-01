use Mix.Config

# Configure your database
config :kjer_si, KjerSi.Repo,
  username: "postgres",
  password: "postgres",
  database: "kjer_si_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kjer_si, KjerSiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
