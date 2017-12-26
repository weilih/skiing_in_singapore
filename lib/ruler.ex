defmodule Ruler do
  def sort_by_grade(routes, map) when is_list(routes) do
    routes
    |> Enum.group_by(&hd/1)
    |> Enum.reduce([], fn ({_coordinate, routes}, acc) ->
         routes = Enum.map(routes, fn (route) -> parse(route, map) end)
         {_length, routes} = find_longest(routes)
         {_steep, routes} = find_steepest(routes)
         [hd(routes) | acc]
       end)
    |> Enum.group_by(&length/1)
    |> Enum.sort_by(fn {length, _routes} -> length end)
    |> Enum.reduce([], fn
        ({1, routes}, acc) ->
          sorted = Enum.sort_by(routes, fn (route) ->
            route |> hd() |> Map.values() |> hd()
          end, &<=/2)
          sorted ++ acc
        ({_length, routes}, acc) ->
          Enum.sort_by(routes, &calc_steepness/1, &>=/2) ++ acc
       end)
  end

  def find_longest(routes) when is_list(routes) do
    routes
    |> Enum.group_by(&length/1)
    |> Enum.max_by(fn {length, _routes} -> length end)
  end

  def find_steepest(routes) when is_list(routes) do
    routes
    |> Enum.group_by(&calc_steepness/1)
    |> Enum.max_by(fn {steep, _routes} -> steep end)
  end

  defp calc_steepness([head | _] = route) when is_map(head) do
    path = Enum.flat_map(route, &(Map.values/1))
    List.first(path) - List.last(path)
  end

  defp parse(route, map) when is_list(route) do
    Enum.map(route, fn
      (coor) when is_tuple(coor) -> Map.take(map, [coor])
      (pair) when is_map(pair) -> pair
    end)
  end
end
