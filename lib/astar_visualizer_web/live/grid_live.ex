defmodule AstarVisualizerWeb.GridLive do
  use AstarVisualizerWeb, :live_view
  alias AstarVisualizer.Pathfinding

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       grid: init_grid(20, 20),
       start: {0, 0},
       goal: {19, 19},
       dragging: nil,
       path: [],
       visited: MapSet.new()
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1>A* Pathfinding Visualization</h1>
      <div class="instructions">
        <p>Click on cells to add/remove walls. Drag S and G to set start and goal.</p>
      </div>
      <div class="grid-container">
        <div class="grid">
          <%= for {row, y} <- Enum.with_index(@grid) do %>
            <div class="row">
              <%= for {cell, x} <- Enum.with_index(row) do %>
                <div
                  class={"cell #{cell_class(cell, {x, y}, @start, @goal, @path, @visited)}"}
                  phx-click="toggle_wall"
                  phx-value-x={x}
                  phx-value-y={y}
                >
                  <%= if {x, y} == @start do %>
                    <div class="marker start" draggable="true" phx-hook="Draggable" id="start-marker">
                      S
                    </div>
                  <% end %>
                  <%= if {x, y} == @goal do %>
                    <div class="marker goal" draggable="true" phx-hook="Draggable" id="goal-marker">
                      G
                    </div>
                  <% end %>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
      <div class="controls">
        <button phx-click="start_pathfinding" class="btn btn-primary">
          <i class="fas fa-play"></i> Start Pathfinding
        </button>
        <button phx-click="clear_grid" class="btn btn-secondary">
          <i class="fas fa-trash"></i> Clear Grid
        </button>
      </div>
      <div class="legend">
        <div class="legend-item">
          <div class="cell empty"></div>
          Empty
        </div>
        <div class="legend-item">
          <div class="cell wall"></div>
          Wall
        </div>
        <div class="legend-item">
          <div class="cell visited"></div>
          Visited
        </div>
        <div class="legend-item">
          <div class="cell path"></div>
          Path
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("toggle_wall", %{"x" => x, "y" => y}, socket) do
    {x, y} = {String.to_integer(x), String.to_integer(y)}

    new_grid =
      update_in(socket.assigns.grid, [Access.at(y), Access.at(x)], fn
        :wall -> :empty
        :empty -> :wall
        other -> other
      end)

    {:noreply, assign(socket, grid: new_grid, path: [], visited: MapSet.new())}
  end

  @impl true
  def handle_event("start_pathfinding", _, socket) do
    %{grid: grid, start: start, goal: goal} = socket.assigns

    case Pathfinding.astar(grid, start, goal) do
      nil ->
        {:noreply, put_flash(socket, :error, "No path found!")}

      {path, visited} ->
        Process.send_after(self(), {:animate_path, path, visited}, 100)
        {:noreply, assign(socket, path: [], visited: MapSet.new())}
    end
  end

  @impl true
  def handle_event("clear_grid", _, socket) do
    {:noreply,
     assign(socket,
       grid: init_grid(20, 20),
       path: [],
       visited: MapSet.new()
     )}
  end

  @impl true
  def handle_event("drag", %{"id" => id, "x" => x, "y" => y}, socket) do
    {x, y} = {String.to_integer(x), String.to_integer(y)}

    case id do
      "start-marker" -> {:noreply, assign(socket, start: {x, y}, path: [], visited: MapSet.new())}
      "goal-marker" -> {:noreply, assign(socket, goal: {x, y}, path: [], visited: MapSet.new())}
      _ -> {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:animate_path, [next | rest], visited}, socket) do
    Process.send_after(self(), {:animate_path, rest, visited}, 100)

    {:noreply,
     socket
     |> update(:path, &[next | &1])
     |> update(:visited, &MapSet.put(&1, next))}
  end

  @impl true
  def handle_info({:animate_path, [], _}, socket) do
    {:noreply, socket}
  end

  defp cell_class(cell_type, coords, start, goal, path, visited) do
    cond do
      coords == start -> "start"
      coords == goal -> "goal"
      coords in path -> "path"
      coords in visited -> "visited"
      cell_type == :wall -> "wall"
      true -> "empty"
    end
  end

  defp init_grid(width, height) do
    for _ <- 1..height, do: for(_ <- 1..width, do: :empty)
  end
end
