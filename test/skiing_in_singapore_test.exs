defmodule SkiingInSingaporeTest do
  use ExUnit.Case
  doctest SkiingInSingapore

  test "solve!" do
    assert SkiingInSingapore.solve!("map.txt") ==
      %{steepest: "9->5->3->2->1", longest: 5}
  end
end
