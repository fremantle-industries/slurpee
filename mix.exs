defmodule Slurpee.MixProject do
  use Mix.Project

  def project do
    [
      app: :slurpee,
      version: "0.0.18",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      mod: {Slurpee.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:dev), do: ["lib", "examples"]
  defp elixirc_paths(:test), do: ["lib", "examples", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:confex, "~> 3.5"},
      {:deque, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:navigator, "~> 0.0.8"},
      {:notified_phoenix, "~> 0.0.7"},
      {:phoenix, "~> 1.6.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_react, "~> 0.4.1"},
      {:phoenix_live_view, "~> 0.17"},
      {:plug_cowboy, "~> 2.0"},
      {:redirect, "~> 0.3"},
      # {:slurp, github: "fremantle-industries/slurp", branch: "main"},
      {:slurp, "~> 0.0.12"},
      # {:stylish, github: "fremantle-industries/stylish", branch: "main"},
      {:stylish, "~> 0.0.9"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 1.0"},
      {:excoveralls, "~> 0.8", only: :test},
      {:ex_unit_notifier, "~> 1.0", only: :test},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:logger_file_backend, "~> 0.0.10", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"]
    ]
  end

  defp description do
    "A GUI to manage EVM blockchain ingestion"
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-industries/slurpee"}
    }
  end
end
