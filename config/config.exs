# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :slurpee, SlurpeeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aklUQV064QnGvw4oQ9e+Sp5fmTlkig09P/bxk3AfCSsYHQPDVeHfL9h08XUnr9xY",
  render_errors: [view: SlurpeeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Slurpee.PubSub,
  live_view: [signing_salt: "ecn/jrqJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
