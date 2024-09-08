defmodule AstarVisualizer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AstarVisualizerWeb.Telemetry,
      AstarVisualizer.Repo,
      {DNSCluster, query: Application.get_env(:astar_visualizer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AstarVisualizer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AstarVisualizer.Finch},
      # Start a worker by calling: AstarVisualizer.Worker.start_link(arg)
      # {AstarVisualizer.Worker, arg},
      # Start to serve requests, typically the last entry
      AstarVisualizerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AstarVisualizer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AstarVisualizerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
