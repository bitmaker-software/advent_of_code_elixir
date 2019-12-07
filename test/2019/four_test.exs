defmodule AdventOfCode.Y2019.FourTest do
  use ExUnit.Case
  alias AdventOfCode.Y2019.Four
  doctest AdventOfCode.Y2019.Four


  test "check double" do
    assert Four.check_double({:ok, [1, 2, 2, 4]}) == {:ok, [1, 2, 2, 4]}
  end

  test "check not double" do
    assert Four.check_double({:ok, [1, 2, 3, 4]}) == {:nok, [1, 2, 3, 4]}
  end

  test "check not decrease" do
    assert Four.check_decrease({:ok, [1, 2, 2, 4]}) == {:ok, [1, 2, 2, 4]}
  end

  test "check decrease" do
    assert Four.check_decrease({:ok, [1, 2, 2, 4, 3]}) == {:nok, [1, 2, 2, 4, 3]}
  end
  

  # Part #2

  test "check #2 sample 1" do
    {status, _} = Four.run_for_number_2(112233)
    assert status == :ok
  end

  test "check #2 sample 2" do
    {status, _} = Four.run_for_number_2(123444)
    assert status == :nok
  end

  test "check #2 sample 3" do
    {status, _} = Four.run_for_number_2(111122)
    assert status == :ok
  end

end
