defmodule Kakte.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kakte,
      version: "0.1.0-dev",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [
        plt_add_deps: :transitive,
        flags: [:unmatched_returns, :error_handling, :race_conditions],
        ignore_warnings: ".dialyzer-ignore"
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      mod: {Kakte.Application, []},
      extra_applications: [:logger, :mnesia, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # Development and test dependencies
      {:credo, "~> 0.8.10", only: [:dev, :test], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:excoveralls, ">= 0.0.0", only: :test, runtime: false},
      {:mix_test_watch, ">= 0.0.0", only: :dev, runtime: false},
      {:ex_unit_notifier, ">= 0.0.0", only: :test, runtime: false},
      {:phoenix_live_reload, "~> 1.0", only: :dev},

      # Project dependencies
      {:phoenix, "~> 1.3.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.3"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.14.0"},
      {:cowboy, "~> 1.0"},
      {:expected, "~> 0.1.1"},
      {:plug_session_mnesia, "~> 0.1.2"},
      {:plug_best, "~> 0.3.0"},
      {:timex, "~> 3.1"},
      {:timex_ecto, "~> 3.1"},
      {:comeonin, "~> 4.1"},
      {:bcrypt_elixir, "~> 1.0"},
      {:not_qwerty123, "~> 2.2"}
    ]
  end

  defp aliases do
    [
      setup: ["ecto.setup", "session.setup", "expected.mnesia.setup"],
      reset: ["ecto.reset", "session.clear", "expected.mnesia.clear"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
