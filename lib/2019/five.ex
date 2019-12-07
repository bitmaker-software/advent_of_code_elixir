defmodule AdventOfCode.Y2019.Five do
  alias AdventOfCode.Tools

  # The file containing the input data
  @filename "#{Path.dirname(__ENV__.file)}/five_input.txt"
  
  #
  # Part #1
  #

  # :halt
  def operation(%{context: %{program: program, index: index}, opcode: :halt}), do: %{status: :stopped, program: program, index: index + 1}
  
  # :add
  def operation(%{context: %{program: program, index: index}, opcode: :add, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    arg2 = read_value(program, mode, params, 2)
    value = arg1 + arg2
    new_program = write_value(program, params, 3, value)
    %{status: :running, program: new_program, index: index + 4}
  end

  # :multiply
  def operation(%{context: %{program: program, index: index}, opcode: :multiply, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    arg2 = read_value(program, mode, params, 2)
    value = arg1 * arg2
    new_program = write_value(program, params, 3, value)
    %{status: :running, program: new_program, index: index + 4}
  end

  # :save
  def operation(%{context: %{program: program, index: index}, opcode: :save, mode: mode, params: params}) do
    value = 
    IO.gets("Please enter a value\n> ")
    |> String.trim()
    |> String.to_integer()

    new_program = write_value(program, params, 1, value)
    %{status: :running, program: new_program, index: index + 2}
  end

  # :output
  def operation(%{context: %{program: program, index: index}, opcode: :output, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    IO.puts("#{arg1}\n")
    %{status: :running, program: program, index: index + 2}
  end

  # :jump_if_true
  def operation(%{context: %{program: program, index: index}, opcode: :jump_if_true, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    new_index =
    if arg1 != 0 do
      read_value(program, mode, params, 2)
    else
      index + 3
    end
    %{status: :running, program: program, index: new_index}
  end

  # :jump_if_false
  def operation(%{context: %{program: program, index: index}, opcode: :jump_if_false, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    new_index =
    if arg1 == 0 do
      read_value(program, mode, params, 2)
    else
      index + 3
    end
    %{status: :running, program: program, index: new_index}
  end

  # :lt
  def operation(%{context: %{program: program, index: index}, opcode: :lt, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    arg2 = read_value(program, mode, params, 2)
    value =
    if arg1 < arg2 do
      1
    else
      0
    end
    new_program = write_value(program, params, 3, value)
    %{status: :running, program: new_program, index: index + 4}
  end

  # :eq
  def operation(%{context: %{program: program, index: index}, opcode: :eq, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    arg2 = read_value(program, mode, params, 2)
    value =
    if arg1 == arg2 do
      1
    else
      0
    end
    new_program = write_value(program, params, 3, value)
    %{status: :running, program: new_program, index: index + 4}
  end

  def write_value(program, params, parm_index, value) when length(params) >= parm_index and parm_index > 0 do
    position = Enum.at(params, parm_index - 1)
    List.replace_at(program, position, value)
  end
  def write_value(program, _params, _parm_index, _value), do: program

  def read_value(program, mode, params, parm_index) when length(params) >= parm_index and parm_index > 0 do
    mode_list = [0, 0, 0] ++ Tools.split_number_into_digits(mode)
    case mode_list |> Enum.at(-1 * parm_index) do
      0 -> program |> Enum.at(Enum.at(params, parm_index - 1))
      1 -> params |> Enum.at(parm_index - 1)
    end
  end
  def read_value(_program, _mode, _params, _parm_index), do: nil

  def decode(1), do: :add
  def decode(2), do: :multiply
  def decode(3), do: :save
  def decode(4), do: :output
  def decode(5), do: :jump_if_true
  def decode(6), do: :jump_if_false
  def decode(7), do: :lt
  def decode(8), do: :eq
  def decode(99), do: :halt
  def decode(_), do: :halt

  def decode_operation(context, [op|params]) do
    %{context: context, opcode: decode(rem(op, 100)), mode: div(op, 100), params: params}
  end
  
  # Terminate the program
  def next_operation(%{status: :stopped, program: program, index: _index}), do: program
    
  # get the next operation
  def next_operation(%{status: :running, program: program, index: index} = context) do
    params = Enum.slice(program, index, length(program) - index)
    context
    |> decode_operation(params)
    |> operation()
    |> next_operation()
  end

  # the program start
  def start_program(program) do
    %{status: :running, program: program, index: 0}
    |> next_operation()
  end

  def run() do
    Tools.read_int_list_from_file(@filename)
    |> start_program()
  end

  #
  # Part #2
  #

  def run_test() do
    IO.gets("Please enter a program sequence\n> ")
    |> String.trim()
    |> Tools.read_int_list_from_string()
    |> start_program()
  end

  def run_2() do
    Tools.read_int_list_from_file(@filename)
    |> start_program()
  end
end
