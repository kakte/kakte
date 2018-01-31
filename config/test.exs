use Mix.Config

# We don't run a server during test. If one is required, you can enable the
# server option below.
config :kakte, KakteWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Avoid taking too long to compute password hashes
config :bcrypt_elixir, :log_rounds, 4

# Use the memory store for logins and ETS for sessions to avoid creating Mnesia
# artifacts during the tests.
config :expected,
  store: :memory,
  process_name: :login_store,
  auth_cookie: "_kakte_auth",
  session_store: :ets,
  session_opts: [table: :session],
  session_cookie: "_kakte_key"

# Configures the database
config :kakte, Kakte.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "kakte_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
