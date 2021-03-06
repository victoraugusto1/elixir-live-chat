# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :live_chat, LiveChat.Repo,
  database: "live_chat_repo",
  username: "live_chat",
  password: "live_chat",
  hostname: "localhost"

# Configures the endpoint
config :live_chat, LiveChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aiGRPq5f4csiZBH3NM8NAuhmivqWUPN861dihWiUGAR4iXZnHlFfudAtIT2IKITA",
  render_errors: [view: LiveChatWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveChat.PubSub,
  live_view: [signing_salt: "VqDO/YMm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :live_chat, ecto_repos: [LiveChat.Repo]
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
