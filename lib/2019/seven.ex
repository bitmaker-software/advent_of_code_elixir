defmodule AdventOfCode.Y2019.Seven do
  alias AdventOfCode.Tools

  # The file containing the input data
  @filename "#{Path.dirname(__ENV__.file)}/seven_input.txt"
  
  #
  # Part #1
  #

  # :halt
  def operation(%{context: %{program: program, index: index, inputs: inputs, outputs: outputs}, opcode: :halt}), do: %{status: :stopped, program: program, index: index + 1, inputs: inputs, outputs: outputs}
  
  # :add
  def operation(%{context: %{program: program, index: index, inputs: inputs, outputs: outputs}, opcode: :add, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    arg2 = read_value(program, mode, params, 2)
    value = arg1 + arg2
    new_program = write_value(program, params, 3, value)
    %{status: :running, program: new_program, index: index + 4, inputs: inputs, outputs: outputs}
  end

  # :multiply
  def operation(%{context: %{program: program, index: index, inputs: inputs, outputs: outputs}, opcode: :multiply, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    arg2 = read_value(program, mode, params, 2)
    value = arg1 * arg2
    new_program = write_value(program, params, 3, value)
    %{status: :running, program: new_program, index: index + 4, inputs: inputs, outputs: outputs}
  end

  # :save - if inputs is an empty list, stop the program until we have more inputs
  def operation(%{context: %{program: program, index: index, inputs: [], outputs: outputs}, opcode: :save, mode: mode, params: params}) do
    %{status: :wait, program: program, index: index, inputs: [], outputs: outputs}
  end

  # :save
  def operation(%{context: %{program: program, index: index, inputs: inputs, outputs: outputs}, opcode: :save, mode: mode, params: params}) do
    {value, new_inputs} = inputs |> List.pop_at(0)
    IO.puts("Using input #{value}\n")
    #IO.gets("Please enter a value\n> ")
    #|> String.trim()
    #|> String.to_integer()

    new_program = write_value(program, params, 1, value)
    %{status: :running, program: new_program, index: index + 2, inputs: new_inputs, outputs: outputs}
  end

  # :output
  def operation(%{context: %{program: program, index: index, inputs: inputs, outputs: outputs}, opcode: :output, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    IO.puts("#{arg1}\n")
    new_outputs = outputs ++ [arg1] #inputs |> List.insert_at(0, arg1)
    %{status: :running, program: program, index: index + 2, inputs: inputs, outputs: new_outputs}
  end

  # :jump_if_true
  def operation(%{context: %{program: program, index: index, inputs: inputs, outputs: outputs}, opcode: :jump_if_true, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    new_index =
    if arg1 != 0 do
      read_value(program, mode, params, 2)
    else
      index + 3
    end
    %{status: :running, program: program, index: new_index, inputs: inputs, outputs: outputs}
  end

  # :jump_if_false
  def operation(%{context: %{program: program, index: index, inputs: inputs, outputs: outputs}, opcode: :jump_if_false, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    new_index =
    if arg1 == 0 do
      read_value(program, mode, params, 2)
    else
      index + 3
    end
    %{status: :running, program: program, index: new_index, inputs: inputs, outputs: outputs}
  end

  # :lt
  def operation(%{context: %{program: program, index: index, inputs: inputs, outputs: outputs}, opcode: :lt, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    arg2 = read_value(program, mode, params, 2)
    value =
    if arg1 < arg2 do
      1
    else
      0
    end
    new_program = write_value(program, params, 3, value)
    %{status: :running, program: new_program, index: index + 4, inputs: inputs, outputs: outputs}
  end

  # :eq
  def operation(%{context: %{program: program, index: index, inputs: inputs, outputs: outputs}, opcode: :eq, mode: mode, params: params}) do
    arg1 = read_value(program, mode, params, 1)
    arg2 = read_value(program, mode, params, 2)
    value =
    if arg1 == arg2 do
      1
    else
      0
    end
    new_program = write_value(program, params, 3, value)
    %{status: :running, program: new_program, index: index + 4, inputs: inputs, outputs: outputs}
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
  
  # Wait on the current operation
  def next_operation(%{status: :wait, program: program} = context), do: context

  # Terminate the program
  def next_operation(%{status: :stopped, program: program} = context), do: context
    
  # get the next operation
  def next_operation(%{status: :running, program: program, index: index, inputs: inputs, outputs: outputs} = context) do
    params = Enum.slice(program, index, length(program) - index)
    context
    |> decode_operation(params)
    |> operation()
    |> next_operation()
  end

  # the program start
  def start_program(program, inputs, index \\0) do
    %{status: :running, program: program, index: index, inputs: inputs, outputs: []}
    |> next_operation()
  end

  def run_program(program, inputs, phases, amp \\ 1)
  def run_program(program, inputs, phases, amp) when amp > 5, do: inputs |> List.first()
  def run_program(program, inputs, phases, amp) do

    {phase, new_phases} = phases |> List.pop_at(0)
    program_inputs = 
    case phase do
      nil -> inputs
      value -> [value]++inputs
    end
    
    %{inputs: new_inputs, outputs: outputs} = 
    program 
    |> start_program(program_inputs)

    program 
    |> run_program(outputs, new_phases, amp + 1)
  end 

  def run_test() do

    program = IO.gets("Please enter a program sequence\n> ")
    |> String.trim()
    |> Tools.read_int_list_from_string()

    phase = 
    IO.gets("Now enter the phase settings\n> ")
    |> String.trim()
    |> Tools.split_string_into_digits()
    #|> start_program()

    #program = Tools.read_int_list_from_file(@filename)

    program 
    |> run_program([0], phase)
    
  end

  def run() do
    program = Tools.read_int_list_from_file(@filename)
    
    Tools.permutations([0, 1, 2, 3, 4])
    |> Enum.reduce(0, fn(phase, max) -> 
      value = program |> run_program([0], phase, 1)
      if value > max do
        value
      else
        max
      end
    end)
    
  end

  #
  # Part #2
  #

  def run_program_on_amp(%{program: program, index: index, inputs: inputs, phase: phase}) do

    program_inputs = 
    case phase do
      nil -> inputs
      value -> [value]++inputs
    end

    %{status: status, program: new_program, index: new_index, inputs: new_inputs, outputs: outputs} = 
    program 
    |> start_program(program_inputs, index)

    %{status: status, program: new_program, index: new_index, outputs: outputs, phase: nil} 
  end 

  def setup_system(program, phases) do
    amps = 
    for phase <- phases do
      %{program: program, index: 0, inputs: [], phase: phase}
    end
  end

  def start_system([], inputs), do: inputs |> List.first()
  def start_system(amps, inputs) do
   
    {new_amps, new_outputs} = 
    amps 
    |> Enum.reduce({[], inputs}, fn(%{program: program, index: index, phase: phase}, {amps, outputs}) -> 
      amp_result = run_program_on_amp(%{program: program, index: index, inputs: outputs, phase: phase})
      case amp_result do
        %{status: :stopped} -> {amps, amp_result.outputs}
        value -> {amps ++ [value], amp_result.outputs}
      end
    end)

    start_system(new_amps, new_outputs)
  end

  def run_system(program, phases) do
    setup_system(program, phases)
    |> start_system([0])
  end

  def run_test_2() do

    program = IO.gets("Please enter a program sequence\n> ")
    |> String.trim()
    |> Tools.read_int_list_from_string()

    inputs = 
    IO.gets("Now enter the phase settings\n> ")
    |> String.trim()
    #|> Tools.split_string_into_digits()
    |> Tools.read_int_list_from_string()
    #|> start_program()

    #program = Tools.read_int_list_from_file(@filename)

    program 
    |> start_program(inputs)
    #|> run_program(input)
    
  end

  def run_2() do
    #Tools.read_int_list_from_file(@filename)
    #|> run_system(Tools.split_number_into_digits(98765))

    program = Tools.read_int_list_from_file(@filename)
    
    Tools.permutations([5, 6, 7, 8, 9])
    |> Enum.reduce(0, fn(phase, max) -> 
      value = program |> run_system(phase)
      if value > max do
        value
      else
        max
      end
    end)

  end
end
