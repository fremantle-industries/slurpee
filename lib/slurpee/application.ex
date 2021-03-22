defmodule Slurpee.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      SlurpeeWeb.Telemetry,
      {Phoenix.PubSub, name: Slurpee.PubSub},
      Slurpee.RecentHeads,
      Slurpee.RecentEvents,
      Slurpee.BlockchainStatistics,
      SlurpeeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Slurpee.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SlurpeeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
