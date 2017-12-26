defmodule Route do
  def find_next(coordinate, map) do
    coordinate
    |> routes(map)
    |> find_next([], map)
    |> evaluate_routes(coordinate, map)
    |> Enum.reduce(map, fn (route, acc) -> update_map(route, acc) end)
  end

  defp find_next([], traveled, _map), do: [Enum.reverse(traveled)]
  defp find_next(routes, traveled, map) do
    Enum.flat_map(routes, fn(coor) ->
      case Map.fetch(map, coor) do
        {:ok, %Point{route: nil}} ->
          find_next(routes(coor, map), [coor|traveled], map)

        {:ok, %Point{route: route}} when is_list(route) ->
          find_next([], Enum.reverse(route) ++ traveled, map)
      end
    end)
  end

  defp evaluate_routes([[]], coordinate, _map), do: [[coordinate]]
  defp evaluate_route(route, coordinate, _map) when length(route) == 1 do
    [[coordinate|route]]
  end
  defp evaluate_routes(routes, coordinate, map) do
    [best_route | other_routes] = Ruler.sort_by_grade(routes, map)
    [[coordinate | best_route] | other_routes]
  end

  defp update_map([], map), do: map
  defp update_map([coordinate | tail] = route, map) do
    {_point, new_map} =
      Map.get_and_update!(map, coordinate, fn (point) ->
        new_point =
          case point do
            %Point{route: nil} ->
              %{point | route: route}
                |> Point.route_to_path(map)
                |> Point.path_steep()
                |> Point.distance()
            _ -> point
          end
        {point, new_point}
      end)
    update_map(tail, new_map)
  end

  defp routes(coordinate, map) do
    current_point = Map.fetch!(map, coordinate)

    Enum.filter(directions(coordinate), fn(coor) ->
      with {:ok, next_point} <- Map.fetch(map, coor),
        true <- current_point.value > next_point.value
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
