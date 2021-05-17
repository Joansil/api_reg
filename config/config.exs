# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api_reg,
  ecto_repos: [ApiReg.Repo]

# Configures the endpoint
config :api_reg, ApiRegWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4VkH6lQ9hzHALA3lWEGQFAkF8/AxIamorHHhvNxld+9ISm2+YcbJZ+7V455M99Yo",
  render_errors: [view: ApiRegWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ApiReg.PubSub,
  live_view: [signing_salt: "D6M9Cbup"]

config :api_reg, ApiReg.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :api_reg, ApiReg.Accounts.Auth.Guardian,
  issuer: "api_reg",
  secret_key: System.get_env("GUARDIAN_SECRET")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
