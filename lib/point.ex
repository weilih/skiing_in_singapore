defmodule Point do
  @enforce_keys [:coordinate, :value]
  defstruct [:coordinate, :value, :route, :path, :len, :steep]

  def distance(%Point{route: route} = point), do: %{point | len: length(route)}

  def route_to_path(%Point{route: route} = point, map) when is_list(route) do
    path = Enum.map(route, fn(coor) -> Map.fetch!(map, coor).value end)
    %{point | path: path}
  end

  def path_steep(%Point{path: path} = point) when is_list(path) do
    steep = List.first(path) - List.last(path)
    %{point | steep: steep}
  end
end
