defmodule SkiingInSingaporeTest do
  use ExUnit.Case
  doctest SkiingInSingapore

  test "solve!('test.txt')" do
    assert SkiingInSingapore.solve!("test.txt") == %{steepest: 8, longest: 5}
  end

  @tag map: true
  test "solve!('map.txt')" do
    assert SkiingInSingapore.solve!("map.txt") == %{steepest: 1422, longest: 15}
  end
end
