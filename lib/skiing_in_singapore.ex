defmodule SkiingInSingapore do
  def solve!(filename \\ "test.txt") do
    list = load_data(filename)
    map = Map.new(list)

    max_point =
      list
      |> Enum.sort_by(fn {_coor, point} -> point.value end, &>=/2)
      |> Enum.reduce(map, fn ({coor, _point}, acc) ->
           Route.find_next(coor, acc)
         end)
      |> Map.values()
      |> Enum.group_by(fn (point) -> point.len end)
      |> Enum.max_by(fn {length, _points} -> length end)
      |> case do
           {_len, points} -> Enum.max_by(points, fn (point) -> point.steep end)
         end

    %{longest: max_point.len, steepest: max_point.steep}
  end

  defp load_data(filename) do
    [_info | input_list] =
      filename |> File.read!() |> String.trim() |> String.split("\n")

    input_list
    |> Enum.with_index()
    |> Enum.flat_map(fn({row, index}) -> insert_line(index, row) end)
  end

  defp insert_line(row_index, line) do
    line
    |> String.split("\s")
    |> Enum.with_index()
    |> Enum.map(fn {value, col_index} ->
         coor = {row_index, col_index}
         { coor, %Point{coordinate: coor, value: String.to_integer(value)} }
       end)
  end
end
