defmodule AdventOfCode.Y2019.Two do
  alias AdventOfCode.Tools

  # The file containing the input data
  @filename "#{Path.dirname(__ENV__.file)}/two_input.txt"
  
  #
  # Part #1
  #

  # add
  def execute(1, arg1, arg2), do: arg1 + arg2
  # multiply
  def execute(2, arg1, arg2), do: arg1 * arg2

  # end of program
  def operation(%{status: :running, program: program, index: index}, [99|_params]), do: %{status: :stopped, program: program, index: index + 1}
  
  # 2-nary operations
  def operation(%{status: :running, program: program, index: index}, [op|params]) do
    arg1 = program |> Enum.at(Enum.at(params, 0))
    arg2 = program |> Enum.at(Enum.at(params, 1))
    position = Enum.at(params, 2)
    value = execute(op, arg1, arg2)
    new_program = List.replace_at(program, position, value)
    %{status: :running, program: new_program, index: index + 4}
  end
  
  
  # unknown operation
  #def operation(%{status: :running, program: program, index: index}, [op|_params]), do: %{status: :stopped, program: program, index: index}

  # Terminate the program
  def next_operation(%{status: :stopped, program: program, index: _index}), do: program
    
  # get the next operation
  def next_operation(%{status: :running, program: program, index: index} = context) do
    params = Enum.slice(program, index, length(program) - index)
    context
    |> operation(params)
    |> next_operation()
  end

  # the program start
  def start_program(program) do
    %{status: :running, program: program, index: 0}
    |> next_operation()
  end

  def run() do
    Tools.read_int_list_from_file(@filename)
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> start_program()
    |> Enum.at(0)
  end

  #
  # Part #2
  #

  def run_for(program, noun, verb) do
    program
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> start_program()
    |> Enum.at(0)
  end

  def start_program_2(program) do
    try do
      for noun <- 0..99 do
        for verb <- 0..99 do 
          if run_for(program, noun, verb) == 19690720 do
            IO.inspect({noun, verb}, label: "found")
            throw {:halt, noun, verb}
          end
        end
      end  
    catch
      :throw, {:halt, noun, verb} -> 100 * noun + verb
    end
  
  end

  def run_2() do
    Tools.read_int_list_from_file(@filename)
    |> start_program_2()
  end
end
