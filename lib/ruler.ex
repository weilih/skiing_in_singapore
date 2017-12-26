defmodule Ruler do
  def sort_by_grade(routes, map) when is_list(routes) do
    routes
    |> Enum.group_by(&hd/1)
    |> Enum.reduce([], fn ({_coordinate, routes}, acc) ->
         {_length, routes} = find_longest(routes)
         {_steep, routes} = find_steepest(routes, map)
         [hd(routes) | acc]
       end)
    |> Enum.sort_by(&length/1, &>=/2)
  end

  defp find_longest(routes) when is_list(routes) do
    routes
    |> Enum.group_by(&length/1)
    |> Enum.max_by(fn {length, _routes} -> length end)
  end

  defp find_steepest(routes, map) when is_list(routes) do
    routes
    |> Enum.group_by(fn (route) -> calc_steepness(route, map) end)
    |> Enum.max_by(fn {steep, _routes} -> steep end)
  end

  defp calc_steepness(route, map) when is_list(route) do
    map[List.first(route)].value - map[List.last(route)].value
  end
end
