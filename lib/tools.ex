defmodule AdventOfCode.Tools do
  
  def parse_integer(str, default \\ 0) do
    case Integer.parse(str) do
      :error -> default
      {value, _} -> value
    end
  end

  def read_line do
    case IO.read(:stdio, :line) do
      :eof -> :ok
      {:error, reason} -> IO.puts "Error: #{reason}"
      data ->
        IO.write(:stdio, data)
        data
    end
  end

  @doc """
  Read all lines until an empty line is found
  """
  def read_lines(lines \\ []) do
    case IO.read(:stdio, :line) do
      :eof -> :ok
      {:error, reason} -> IO.puts "Error: #{reason}"
      data ->
        line = String.trim(data)  
        case line do
          "" -> lines
          _ -> 
            lines ++ [line]
            |> read_lines()  
        end
    end
  end

  @doc """
  Reads a single line containing a list of integers separated by a space
  and put them into a list
  """
  def read_int_list_from_console do
    read_line()
    |> String.split(" ")
    |> Enum.map(fn str -> parse_integer(str) end)
  end

  @doc """
  Reads a bunch of lines containing and integer until an empty 
  line is found and put them into a list
  """
  def read_int_lines_from_console do
    read_lines()
    |> Enum.map(fn str -> parse_integer(str) end)
  end

  def read_int_lines_from_file(filename) do
    File.stream!(filename) 
    |> Stream.map(&String.trim(&1)) 
    |> Stream.map(&Integer.parse(&1) |> elem(0)) 
    |> Enum.to_list()  
  end

  def read_int_list_from_file(filename) do
    File.stream!(filename) 
    |> Enum.to_list()
    |> Enum.at(0)
    |> String.split(",")
    |> Enum.map(fn str -> parse_integer(str) end)
  end

  #AdventOfCode.Tools.read_list_from_file("lib/2019/three_input.txt")
  def read_list_from_file(filename) do
    File.stream!(filename) 
    |> Stream.map(&String.split(&1, ","))
    |> Enum.to_list() 
  end

  def split_number_into_digits(value) do
    list = for <<x::binary-1 <- Integer.to_string(value)>>, do: x
    list |> Enum.map(fn(x) -> String.to_integer(x) end)
  end
end
