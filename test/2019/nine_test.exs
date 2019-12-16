defmodule AdventOfCode.Y2019.NineTest do
  use ExUnit.Case
  alias AdventOfCode.Y2019.Nine
  doctest AdventOfCode.Y2019.Nine

  # Edge cases

  test "check base offset " do
    arguments = %{context: %{program: [109, 19], index: 0, base: 2000}, opcode: :offset, mode: 1, params: [19]}
    %{base: base} = Nine.operation(arguments)  
    assert base == 2019
  end

  test "check base offset + output " do
    arguments = %{context: %{program: [109, 19, 204, -34], index: 2, base: 2019, outputs: []}, opcode: :output, mode: 2, params: [-34]}
    %{outputs: outputs} = Nine.operation(arguments)  
    assert outputs |> List.first() == 0
  end

  test "check write off band" do
    value = 
    "109, 2019, 203, -34, 204, -34, 99"
    |> Nine.run_program_from_string([1143])  
    assert value == 1143
  end

  # Part #2


end
