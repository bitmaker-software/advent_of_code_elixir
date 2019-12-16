defmodule AdventOfCode.Y2019.Nine do
  alias AdventOfCode.Tools

  # The file containing the input data
  @filename "#{Path.dirname(__ENV__.file)}/nine_input.txt"
  
  #
  # Part #1
  #

  # :halt
  def operation(%{context: %{index: index}, opcode: :halt} = arguments) do 
    arguments.context
    |> Map.put(:status, :stopped)
    |> Map.put(:index, index + 1)
  end
  
  # :add
  def operation(%{context: %{program: program, index: index, base: base}, opcode: :add, mode: mode, params: params} = arguments) do
    arg1 = read_value(program, mode, params, 1, base)
    arg2 = read_value(program, mode, params, 2, base)
    value = arg1 + arg2
    new_program = write_value(program, mode, params, 3, base, value)

    arguments.context
    |> Map.put(:status, :running)
    |> Map.put(:program, new_program)
    |> Map.put(:index, index + 4)
  end

  # :multiply
  def operation(%{context: %{program: program, index: index, base: base}, opcode: :multiply, mode: mode, params: params} = arguments) do
    arg1 = read_value(program, mode, params, 1, base)
    arg2 = read_value(program, mode, params, 2, base)
    value = arg1 * arg2
    new_program = write_value(program, mode, params, 3, base, value)

    arguments.context
    |> Map.put(:status, :running)
    |> Map.put(:program, new_program)
    |> Map.put(:index, index + 4)
  end

  # :input - if inputs is an empty list, stop the program until we have more inputs
  def operation(%{context: %{inputs: []}, opcode: :input} = arguments) do
    arguments.context
    |> Map.put(:status, :wait)
  end


  # :input
  def operation(%{context: %{program: program, index: index, inputs: inputs, base: base}, opcode: :input, mode: mode, params: params} = arguments) do
    {value, new_inputs} = inputs |> List.pop_at(0)
    IO.puts("Using input #{value}\n")

    #value = 
    #IO.gets("Please enter a value\n> ")
    #|> String.trim()
    #|> String.to_integer()

    new_program = write_value(program, mode, params, 1, base, value)

    arguments.context
    |> Map.put(:status, :running)
    |> Map.put(:program, new_program)
    |> Map.put(:index, index + 2)
    |> Map.put(:inputs, new_inputs)

  end

  # :output
  def operation(%{context: %{program: program, index: index, outputs: outputs, base: base}, opcode: :output, mode: mode, params: params} = arguments) do
    arg1 = read_value(program, mode, params, 1, base)
    IO.puts("#{arg1}\n")
    new_outputs = outputs ++ [arg1] 

    arguments.context
    |> Map.put(:status, :running)
    |> Map.put(:index, index + 2)
    |> Map.put(:outputs, new_outputs)
  end

  # :jump_if_true
  def operation(%{context: %{program: program, index: index, base: base}, opcode: :jump_if_true, mode: mode, params: params} = arguments) do
    arg1 = read_value(program, mode, params, 1, base)
    new_index =
    if arg1 != 0 do
      read_value(program, mode, params, 2, base)  |> Tools.log("False")
    else
      index + 3 |> Tools.log("True")
    end

    arguments.context
    |> Map.put(:status, :running)
    |> Map.put(:index, new_index)
  end

  # :jump_if_false
  def operation(%{context: %{program: program, index: index, base: base}, opcode: :jump_if_false, mode: mode, params: params} = arguments) do
    arg1 = read_value(program, mode, params, 1, base)
    new_index =
    if arg1 == 0 do
      read_value(program, mode, params, 2, base) |> Tools.log("True")
    else
      index + 3 |> Tools.log("False")
    end

    arguments.context
    |> Map.put(:status, :running)
    |> Map.put(:index, new_index)
  end

  # :lt
  def operation(%{context: %{program: program, index: index, base: base}, opcode: :lt, mode: mode, params: params} = arguments) do
    arg1 = read_value(program, mode, params, 1, base)
    arg2 = read_value(program, mode, params, 2, base)
    value =
    if arg1 < arg2 do
      1  |> Tools.log("True")
    else
      0 |> Tools.log("False")
    end
    new_program = write_value(program, mode, params, 3, base, value)

    arguments.context
    |> Map.put(:status, :running)
    |> Map.put(:program, new_program)
    |> Map.put(:index, index + 4)
  end

  # :eq
  def operation(%{context: %{program: program, index: index, base: base}, opcode: :eq, mode: mode, params: params} = arguments) do
    arg1 = read_value(program, mode, params, 1, base)
    arg2 = read_value(program, mode, params, 2, base)
    value =
    if arg1 == arg2 do
      1 |> Tools.log("True")
    else
      0 |> Tools.log("False")
    end
    new_program = write_value(program, mode, params, 3, base, value)

    arguments.context
    |> Map.put(:status, :running)
    |> Map.put(:program, new_program)
    |> Map.put(:index, index + 4)
  end

  # :offset - if inputs is an empty list, stop the program until we have more inputs
  def operation(%{context: %{program: program, index: index, base: base}, opcode: :offset, mode: mode, params: params} = arguments) do
    value = read_value(program, mode, params, 1, base)
    #IO.puts("Increasing base by #{value} to #{base + value}")
    arguments.context
    |> Map.put(:status, :running)
    |> Map.put(:index, index + 2)
    |> Map.put(:base, base + value)
  end

  def get_mode(mode, parm_index) do
    [0, 0, 0] ++ Tools.split_number_into_digits(mode)
    |> Enum.at(-1 * parm_index) 
  end

  def ensure_list_until_position(program, position) when length(program) > position, do: program
  def ensure_list_until_position(program, position) do
    program ++ for i <- position..length(program), do: 0
  end

  def write_value(program, mode, params, parm_index, base, value) when length(params) >= parm_index and parm_index > 0 do
    parm_value = Enum.at(params, parm_index - 1)
    position = 
    case get_mode(mode, parm_index) do
      0 -> parm_value
      2 -> base + parm_value
    end
    |> Tools.log("Writing to address")

    value |> Tools.log("value")

    program
    |> ensure_list_until_position(position)
    |> List.replace_at(position, value)
    
  end
  def write_value(program, _mode, _params, _parm_index, _base, _value), do: program

  def safe_read(nil), do: 0
  def safe_read(value), do: value

  def safe_address(address) when address < 0, do: throw {:halt, "Cannot read negative memory positions"}
  def safe_address(address), do: address 

  def read_value(program, mode, params, parm_index, base) when length(params) >= parm_index and parm_index > 0 do
    parm_value = Enum.at(params, parm_index - 1)
    case get_mode(mode, parm_index) do
      0 -> 
        Tools.log(parm_value, "Reading from address")
        program |> Enum.at(safe_address(parm_value)) 
      1 -> parm_value
      2 -> 
        Tools.log(base + parm_value, "Reading from address (with base)")
        program |> Enum.at(safe_address(base + parm_value))
    end
    |> safe_read()
    |> Tools.log("value")
  end
  def read_value(_program, _mode, _params, _parm_index, _base), do: nil

  def decode(1), do: :add
  def decode(2), do: :multiply
  def decode(3), do: :input
  def decode(4), do: :output
  def decode(5), do: :jump_if_true
  def decode(6), do: :jump_if_false
  def decode(7), do: :lt
  def decode(8), do: :eq
  def decode(9), do: :offset
  def decode(99), do: :halt
  def decode(_), do: :halt

  def decode_operation(context, [op|params]) do
    %{context: context, opcode: decode(rem(op, 100)), mode: div(op, 100), params: params}
  end
  
  # Wait on the current operation
  def next_operation(%{status: :wait} = context), do: context

  # Terminate the program
  def next_operation(%{status: :stopped} = context), do: context
    
  # get the next operation
  def next_operation(%{status: :running, program: program, index: index} = context) do
    params = Enum.slice(program, index, length(program) - index)
    context
    |> decode_operation(params)
    |> Tools.log("OP")
    |> operation()
    |> next_operation()
  end

  # the program start
  def start_program(program, inputs, index \\0) do
    %{status: :running, program: program, index: index, inputs: inputs, outputs: [], base: 0}
    |> next_operation()
  end

  def run_program_from_string(string, inputs) do
    %{outputs: outputs} = 
    string
    |> String.trim()
    |> Tools.read_int_list_from_string()
    |> start_program(inputs)
    
    outputs |> List.first()
  end
  
  def run_test() do
    program = IO.gets("Please enter a program sequence\n> ")
    |> String.trim()
    |> Tools.read_int_list_from_string()

    program
    |> start_program([])
  end

  def run() do
    %{program: program} = Tools.read_int_list_from_file(@filename)
    |> start_program([1])
  end

  #
  # Part #2
  #

 

  def run_2() do
    %{program: program} = Tools.read_int_list_from_file(@filename)
    |> start_program([2])
  end
end
