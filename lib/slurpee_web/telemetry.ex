defmodule SlurpeeWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000},
      {TelemetryMetricsPrometheus,
       [
         metrics: metrics(),
         name: prometheus_metrics_name(),
         port: prometheus_metrics_port(),
         options: [ref: :"TelemetryMetricsPrometheus.Router.HTTP_#{prometheus_metrics_port()}"]
       ]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Slurp Metrics
      last_value("slurp.blockchains.start", tags: [:id]),
      last_value("slurp.blockchains.stop", tags: [:id]),

      # Phoenix Metrics
      last_value("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      last_value("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      )
    ]
  end

  defp prometheus_metrics_name do
    Application.get_env(:slurpee, :metrics_name, :slurpee_prometheus_metrics)
  end

  defp prometheus_metrics_port do
    Application.get_env(:slurpee, :prometheus_metrics_port, 9568)
  end

  defp periodic_measurements do
    []
  end
end
