defmodule SkiingInSingapore do
  def solve!(filename \\ "test.txt") do
    list = load_data(filename)
    map_list = Map.new(list)

    sorted_list =
      list
      |> Enum.sort_by(fn {_coor, value} -> value end, &>=/2)
      |> Enum.map(fn {coor, _value} -> Route.find_next(coor, map_list) end)
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.sort_by(&length/1, &>=/2)

    max_length = sorted_list |> hd() |> length() |> IO.inspect(label: "longest")

    max_steep =
      sorted_list
      |> Enum.filter(fn (route) -> length(route) == max_length end)
      |> Enum.max_by(fn (route) ->
        first_point = Map.fetch!(map_list, List.first(route))
        last_point = Map.fetch!(map_list, List.last(route))
        first_point - last_point
      end)
      |> IO.inspect(label: "path")
      |> Enum.map_join("->", fn(dot) -> Map.fetch!(map_list, dot) end)

    %{longest: max_length, steepest: max_steep}
  end

  defp load_data(filename) do
    [_info | input_list] =
      filename |> File.read!() |> String.strip() |> String.split("\n")

    input_list
    |> Enum.with_index()
    |> Enum.flat_map(fn({row, index}) -> insert_line(index, row) end)
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
