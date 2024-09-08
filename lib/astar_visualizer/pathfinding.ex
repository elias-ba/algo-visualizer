defmodule AstarVisualizer.Pathfinding do
  def astar(grid, start, goal) do
    open_set = MapSet.new([start])
    came_from = %{}
    g_score = %{start => 0}
    f_score = %{start => heuristic(start, goal)}

    astar_loop(grid, open_set, came_from, g_score, f_score, goal, MapSet.new())
  end

  defp astar_loop(_, open_set, _, _, _, _, visited) when map_size(open_set) == 0, do: nil

  defp astar_loop(grid, open_set, came_from, g_score, f_score, goal, visited) do
    current = Enum.min_by(open_set, &Map.get(f_score, &1, :infinity))

    if current == goal do
      path = reconstruct_path(came_from, current)
      {path, visited}
    else
      visited = MapSet.put(visited, current)

      {open_set, came_from, g_score, f_score} =
        neighbors(grid, current)
        |> Enum.reduce(
          {MapSet.delete(open_set, current), came_from, g_score, f_score},
          fn neighbor, acc ->
            process_neighbor(grid, current, neighbor, goal, acc)
          end
        )

      astar_loop(grid, open_set, came_from, g_score, f_score, goal, visited)
    end
  end

  defp process_neighbor(grid, current, neighbor, goal, {open_set, came_from, g_score, f_score}) do
    tentative_g_score = Map.get(g_score, current, :infinity) + 1

    if tentative_g_score < Map.get(g_score, neighbor, :infinity) do
      came_from = Map.put(came_from, neighbor, current)
      g_score = Map.put(g_score, neighbor, tentative_g_score)
      f_score = Map.put(f_score, neighbor, tentative_g_score + heuristic(neighbor, goal))
      open_set = MapSet.put(open_set, neighbor)
      {open_set, came_from, g_score, f_score}
    else
      {open_set, came_from, g_score, f_score}
    end
  end

  defp reconstruct_path(came_from, current) do
    reconstruct_path_loop(came_from, current, [])
  end

  defp reconstruct_path_loop(came_from, current, path) do
    path = [current | path]

    case Map.get(came_from, current) do
      nil -> path
      next -> reconstruct_path_loop(came_from, next, path)
    end
  end

  defp neighbors(grid, {x, y}) do
    for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0} do
      {x + dx, y + dy}
    end
    |> Enum.filter(&(is_valid_cell?(grid, &1) and get_cell(grid, &1) != :wall))
  end

  defp is_valid_cell?(grid, {x, y}) do
    y >= 0 and y < length(grid) and x >= 0 and x < length(Enum.at(grid, 0))
  end

  defp get_cell(grid, {x, y}) do
    grid |> Enum.at(y) |> Enum.at(x)
  end

  defp heuristic({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
