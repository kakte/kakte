use Mix.Config

# General application configuration
config :kakte,
  ecto_repos: [Kakte.Repo]

# Configures the endpoint
config :kakte, KakteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "V522wbpWk35pzJY88QX5uiYNxEaeO43xpCEM9zy+ps7vcXhR2PDnyoLuwDRKw9jz",
  render_errors: [view: KakteWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kakte.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Expected
config :expected,
  store: :mnesia,
  table: :logins,
  auth_cookie: "_kakte_auth",
  session_store: PlugSessionMnesia.Store,
  session_cookie: "_kakte_key"

# Configures the session store
config :plug_session_mnesia,
  table: :session,
  timestamp: :fixed,
  max_age: 600

# Import environment specific config. This must remain at the bottom of this
# file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
