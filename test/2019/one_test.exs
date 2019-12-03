defmodule AdventOfCode.Y2019.OneTest do
  use ExUnit.Case
  alias AdventOfCode.Y2019.One
  doctest AdventOfCode.Y2019.One

  # Edge cases

  test "check negative mass" do
    assert One.compute(-1) == 0
  end

  test "check zero mass" do
    assert One.compute(0) == 0
  end

  test "check 8" do
    assert One.compute(8) == 0
  end

  test "check 9" do
    assert One.compute(9) == 1
  end

  # Samples

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
    assert One.compute_all([-1, 0, 8, 12, 14, 1969, 100756]) == 34241
  end

  # Part #2

  test "check #2 negative" do
    assert One.compute_2(-1) == 0
  end

  test "check #2 14" do
    assert One.compute_2(14) == 2
  end

  test "check #2 1969" do
    assert One.compute_2(1969) == 966
  end

  test "check #2 100756" do
    assert One.compute_2(100756) == 50346
  end

  test "check #2 sum" do
    assert One.compute_all_2([-1, 8, 14, 1969, 100756]) == 51314
  end
end
