defmodule Route do
  def find_next({lat, long}, map, traveled \\ []) do
    value_center = Map.fetch!(map, {lat, long})
    traveled = [{lat, long}|traveled]

    north = {lat - 1, long}
    south = {lat + 1, long}
    west = {lat, long - 1}
    east = {lat, long + 1}

    Enum.map([north, east, south, west], fn(loc) ->
      with {:ok, next_value} <- Map.fetch(map, loc),
          true <- value_center > next_value
      do
        find_next(loc, map, traveled)
      else
        false ->
          List.to_tuple(traveled)
        _ ->
          List.to_tuple(traveled)
      end
    end)
  end
end
