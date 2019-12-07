defmodule AdventOfCode.Y2019.ThreeTest do
  use ExUnit.Case
  alias AdventOfCode.Y2019.Three
  doctest AdventOfCode.Y2019.Three


  test "check sample #1" do
    lines = [
      ["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
      ["U62","R66","U55","R34","D71","R55","D58","R83"]
    ]
    assert Three.process_lines_by_distance(lines) == 159
  end

  test "check sample #2" do
    lines = [
      ["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
      ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]
    ]
    assert Three.process_lines_by_distance(lines) == 135
  end

  # Part #2

  test "check part #2 sample #1" do
    lines = [
      ["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
      ["U62","R66","U55","R34","D71","R55","D58","R83"]
    ]
    assert Three.process_lines_by_speed(lines) == 610
  end

  test "check part #2 sample #2" do
    lines = [
      ["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
      ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]
    ]
    assert Three.process_lines_by_speed(lines) == 410
  end

end
