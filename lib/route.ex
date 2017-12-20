defmodule Route do
  def find_next(coordinate, map, traveled \\ {}) do
    traveled = Tuple.append(traveled, coordinate)
    current_value = Map.fetch!(map, coordinate)

    Enum.map(directions(coordinate), fn(coor) ->
      with {:ok, next_value} <- Map.fetch(map, coor),
           true <- current_value > next_value
      do
        find_next(coor, map, traveled)
      else
        _ -> traveled
      end
    end)
  end

  defp directions({lat, long}) do
    [{lat - 1, long}, {lat, long + 1}, {lat + 1, long}, {lat, long - 1}]
  end
end
