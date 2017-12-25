defmodule Route do
  def run(coordinate, map) do
    case Map.get(map, coordinate) do
      path when is_list(path) -> map
      value when is_integer(value) -> find_next(coordinate, map)
      nil -> :error
    end
  end

  def find_next(coordinate, map) do
    coordinate
    |> routes(map)
    |> find_next(map, [])
    |> evaluate_routes(coordinate, map)
    |> Enum.reduce(map, &(update_map/2))
  end

  defp find_next([], _map, traveled), do: [Enum.reverse(traveled)]
  defp find_next(routes, map, traveled) do
    Enum.flat_map(routes, fn(coor) ->
      case Map.fetch(map, coor) do
        {:ok, route} when is_list(route) ->
          find_next([], map, Enum.reverse(route) ++ traveled)

        {:ok, value} when is_integer(value) ->
          find_next(routes(coor, map), map, [coor|traveled])
      end
    end)
  end

  defp evaluate_routes([[]], coordinate, _map), do: [[coordinate]]
  defp evaluate_routes(routes, coordinate, map) do
    [best_route | other_routes] = Ruler.sort_by_grade(routes, map)
    [[coordinate | best_route] | other_routes]
  end

  defp update_map([], map), do: map
  defp update_map([path | _], map) when is_map(path), do: map
  defp update_map([coordinate | tail] = route, map) when is_tuple(coordinate) do
    {_value, new_map} =
      Map.get_and_update!(map, coordinate, fn
        (value) when is_list(value) -> {value, value}
        (value) when is_integer(value) ->
          {value, List.update_at(route, 0, &(Map.take(map, [&1])))}
      end)
    update_map(tail, new_map)
  end

  defp routes(coordinate, map) do
    current_value = Map.get(map, coordinate)

    Enum.filter(directions(coordinate), fn(coor) ->
      with next_value when is_integer(next_value) <- fetch_value(coor, map),
        true <- current_value > next_value
      do
        true
      else
        _ -> false
      end
    end)
  end

  defp fetch_value(coordinate, map) do
    case Map.fetch(map, coordinate) do
      {:ok, [%{^coordinate => value} | _]} -> value
      {:ok, value} when is_integer(value) -> value
      :error -> :error
    end
  end

  defp directions({lat, long}) do
    [{lat - 1, long}, {lat, long + 1}, {lat + 1, long}, {lat, long - 1}]
  end
end
