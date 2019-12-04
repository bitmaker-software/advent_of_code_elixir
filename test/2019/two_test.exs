defmodule AdventOfCode.Y2019.TwoTest do
  use ExUnit.Case
  alias AdventOfCode.Y2019.Two
  doctest AdventOfCode.Y2019.Two

  # Edge cases

  test "check end op" do
    assert Two.operation(%{status: :running, program: [99,0,0,0,99], index: 0}, [99,0,0,0,99]) == %{status: :stopped, program: [99,0,0,0,99], index: 1}
  end

  test "check 1 op" do
    assert Two.operation(%{status: :running, program: [1,1,1,1], index: 0}, [1,1,1,1]) == %{status: :running, program: [1,2,1,1], index: 4}
  end

  test "check 2 op" do
    assert Two.operation(%{status: :running, program: [2,1,1,1], index: 0}, [2,1,1,1]) == %{status: :running, program: [2,1,1,1], index: 4}
  end

  test "check sample 1" do
    assert Two.operation(%{status: :running, program: [1,0,0,0,99], index: 0}, [1,0,0,0,99]) == %{status: :running, program: [2,0,0,0,99], index: 4}
  end

  test "check sample 2" do
    assert Two.operation(%{status: :running, program: [2,3,0,3,99], index: 0}, [2,3,0,3,99]) == %{status: :running, program: [2,3,0,6,99], index: 4}
  end

  test "check sample 3" do
    assert Two.start_program([2,4,4,5,99,0]) == [2,4,4,5,99,9801]
  end

  test "check sample 4" do
    assert Two.start_program([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]
  end

  # Part #2


end
