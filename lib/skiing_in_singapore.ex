defmodule SkiingInSingapore do
  def solve!(filename \\ "map.txt") do
    list = load(filename)
    map_list = Map.new(list)
    sorted_list =
      list
      |> Enum.sort_by(fn {_location, value} -> value end, &>=/2)
      |> Enum.map(fn {location, _value} -> location end)
      |> Enum.map(fn(coordinate) -> Route.find_next(coordinate, map_list) end)
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.sort_by(&length/1, &>=/2)

    max_length = sorted_list |> hd() |> length() |> IO.inspect(label: "longest")

    max_steep =
      sorted_list
      |> Enum.filter(fn (route) -> length(route) == max_length end)
      |> Enum.max_by(fn (route) ->
        last = Map.fetch!(map_list, List.last(route))
        first = Map.fetch!(map_list, List.first(route))
        last - first
      end)
      |> Enum.reverse()
      |> IO.inspect(label: "path")
      |> Enum.map_join("->", fn(point) ->
        route = Map.fetch!(map_list, point)
        "#{route}"
      end)
      |> IO.inspect(label: "steepest")

    %{longest: max_length, steepest: max_steep}
  end

  def load(filename) do
    [_info | input_list] =
      File.read!(filename) |> String.strip() |> String.split("\n")

    input_list
    |> Enum.with_index()
    |> Enum.flat_map(fn({row, index}) -> insert_line(index, row) end)
    # |> Map.new()
  end

  defp insert_line(row_index, line) do
    line
    |> String.split("\s")
    |> Enum.with_index()
    |> Enum.map(fn {value, col_index} ->
         { {row_index, col_index}, String.to_integer(value) }
       end)
  end
end
