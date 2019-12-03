defmodule AdventOfCode.Y2019.OneTest do
  use ExUnit.Case
  alias AdventOfCode.Y2019.One
  doctest AdventOfCode.Y2019.One

  test "check negative mass" do
    assert One.compute(-1) == 0
  end

  test "check zero mass" do
    assert One.compute(0) == 0
  end

  test "check 12" do
    assert One.compute(12) == 2
  end

  test "check 14" do
    assert One.compute(14) == 2
  end

  test "check 1969" do
    assert One.compute(1969) == 654
  end

  test "check 100756" do
    assert One.compute(100756) == 33583
  end

  test "check sum" do
    assert One.compute_all([-1, 0, 12, 14, 1969, 100756]) == 34241
  end
end
