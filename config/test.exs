use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_chat, LiveChatWeb.Endpoint,
  http: [port: 4002],
  server: false,
  ecto_repos: [LiveChat.Repo]

# Print only warnings and errors during test
config :logger, level: :warn
