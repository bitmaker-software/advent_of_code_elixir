defmodule AdventOfCode.Y2019.Eight do
  alias AdventOfCode.Tools

  # The file containing the input data
  @filename "#{Path.dirname(__ENV__.file)}/eight_input.txt"
  
  #
  # Part #1
  #

  @width 25
  @layer_size 150

  def decode_input() do
    File.stream!(@filename) 
    |> Stream.map(&Tools.split_string_into_digits(&1))
    |> Enum.to_list() 
    |> List.first()
  end

  def add_layer_digit(layer, [%{index: index}|t]) when index < @layer_size, do: [layer] ++ t
  def add_layer_digit(layer, layers), do: [layer] ++ layers

  def decode_layers(image_data) do
    image_data
    |> Enum.reduce([%{layer: 1, index: 0, count_0: 0, count_1: 0, count_2: 0, data: []}], fn(digit, [h|_t] = layers) -> 
      
      %{layer: layer_no, index: index, count_0: count_0, count_1: count_1, count_2: count_2, data: data} =
      if h.index < @layer_size do
        h
      else
        %{layer: h.layer + 1, index: 0, count_0: 0, count_1: 0, count_2: 0, data: []}
      end

      layer = 
      case digit do 
        0 -> %{layer: layer_no, index: index + 1, count_0: count_0 + 1, count_1: count_1, count_2: count_2, data: data ++ [digit]}
        1 -> %{layer: layer_no, index: index + 1, count_0: count_0, count_1: count_1 + 1, count_2: count_2, data: data ++ [digit]}
        2 -> %{layer: layer_no, index: index + 1, count_0: count_0, count_1: count_1, count_2: count_2 + 1, data: data ++ [digit]}
        _ -> %{layer: layer_no, index: index + 1, count_0: count_0, count_1: count_1, count_2: count_2, data: data ++ [digit]}
      end

      add_layer_digit(layer, layers)
    end)
  end

  def run() do
    
    layer = 
    decode_input()
    |> decode_layers()
    |> Enum.sort(&(&1.count_0 < &2.count_0))
    |> List.first()

    layer.count_1 * layer.count_2
  end

  #
  # Part #2
  #

  def encode_pixel(2, digit), do: digit
  def encode_pixel(1, _digit), do: 1
  def encode_pixel(0, _digit), do: 0

  def encode_layers(layers) do
    transparent_layer = 
    for digit <- 1..@layer_size do
      2
    end

    layers 
    |> Enum.reduce(transparent_layer, fn(%{data: data} = layer, image) -> 
      Enum.zip(image, data) 
      |> Enum.map(fn({left, right}) -> 
        encode_pixel(left, right)
      end)
    end)
  end

  def pretty_print(digit) when digit == 0, do: " "
  def pretty_print(digit) when digit == 1, do: "x"
  def pretty_print(_digit), do: "." 

  def print_data(data) do
    pretty = 
    for digit <- data, into: "" do
      pretty_print(digit)
    end
    IO.puts("#{pretty}")
  end

  def data2string(data) do
    chunks = 
    data 
    |> Enum.chunk_every(@width)
    
    chunks |> Enum.map(fn(chunk) -> 
      print_data(chunk)
    end)

  end

  def run_2() do
    decode_input()
    |> decode_layers()
    |> Enum.sort(&(&1.layer < &2.layer))
    |> encode_layers()
    |> data2string()
  end
end
