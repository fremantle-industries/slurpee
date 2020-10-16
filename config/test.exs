use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
database_url = System.get_env("DATABASE_URL") || ""

config :slurpee, Slurpee.Repo,
  url: "#{String.replace(database_url, "?", "test")}#{System.get_env("MIX_TEST_PARTITION")}",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :slurpee, SlurpeeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
