defmodule Route do
  def find_next(coordinate, map) do
    coordinate
    |> routes(map)
    |> find_next([coordinate], map)
    |> best_route(map)
  end

  defp find_next([], traveled, _map), do: [Enum.reverse(traveled)]
  defp find_next(routes, traveled, map) do
    Enum.flat_map(routes, fn(coor) ->
      find_next(routes(coor, map), [coor | traveled], map)
    end)
  end

  defp best_route(routes, map) when is_list(routes) do
    {_length, routes} = Ruler.find_longest(routes)
    {_steep, [best_route | _]} = Ruler.find_steepest(routes, map)
    best_route
  end

  defp routes(coordinate, map) do
    current_value = Map.fetch!(map, coordinate)

    Enum.filter(directions(coordinate), fn(coor) ->
      with {:ok, next_value} <- Map.fetch(map, coor),
        true <- current_value > next_value
      do
        true
      else
        _ -> false
      end
    end)
  end

  defp directions({lat, long}) do
    [{lat - 1, long}, {lat, long + 1}, {lat + 1, long}, {lat, long - 1}]
  end
end
