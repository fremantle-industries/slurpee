defmodule Slurpee.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Slurpee.Repo,
      # Start the Telemetry supervisor
      SlurpeeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Slurpee.PubSub},
      # Start the Endpoint (http/https)
      SlurpeeWeb.Endpoint
      # Start a worker by calling: Slurpee.Worker.start_link(arg)
      # {Slurpee.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
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
