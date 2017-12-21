defmodule Route do
  def find_next(coordinate, map) do
    find_next(routes(coordinate, map), {coordinate}, map)
  end

  defp find_next([], traveled, _map), do: traveled
  defp find_next(routes, traveled, map) do
    Enum.map(routes, fn(coor) ->
      find_next(routes(coor, map), Tuple.append(traveled, coor), map)
    end)
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
