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

# Configures the database
config :kakte, Kakte.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "kakte_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
