defmodule Ruler do
  def find_longest(routes) when is_list(routes) do
    routes
    |> Enum.group_by(&length/1)
    |> Enum.max_by(fn {length, _routes} -> length end)
  end

  def find_steepest(routes, map) when is_list(routes) do
    routes
    |> Enum.group_by(fn (route) -> find_steepness(route, map) end)
    |> Enum.max_by(fn {steep, _routes} -> steep end)
  end

  defp find_steepness(route, map) do
    map[List.first(route)] - map[List.last(route)]
  end
end
