defmodule AstarVisualizer.Repo do
  use Ecto.Repo,
    otp_app: :astar_visualizer,
    adapter: Ecto.Adapters.Postgres
end
