defmodule AdventOfCode.Y2019.Four do
  alias AdventOfCode.Tools
  alias AdventOfCode.Matrix

  # The file containing the input data
  @input "246540-787419"

  #
  # Part #1
  #

  def decode_input(input) do
    [lower, higher] =
    input
    |> String.split("-")
    {String.to_integer(lower), String.to_integer(higher)}
  end

  def dont_decrease?([], _prev), do: true
  def dont_decrease?([h|t], prev) do
    if h < prev do
      false
    else
      dont_decrease?(t, h)
    end
  end

  def check_decrease({:ok, digits}) do
    case dont_decrease?(digits, -1) do
      true -> {:ok, digits}
      false -> {:nok, digits}
    end
  end
  def check_decrease(value), do: value

  def is_double?([], _prev), do: false
  def is_double?([h|t], prev) do
    if h == prev do
      true
    else
      is_double?(t, h)
    end
  end

  def check_double({:ok, digits}) do
    case is_double?(digits, -1) do
      true -> {:ok, digits}
      false -> {:nok, digits}
    end
  end
  def check_double(value), do: value

  def run_for_number(number) do
    digits =
    number
    |> Tools.split_number_into_digits()

    {:ok, digits}
    |> check_double()
    |> check_decrease()
  end

  def count_in_range(numbers) do
    numbers
    |> Enum.reduce(0, fn(number, hits) -> 
      case run_for_number(number) do
        {:ok, _} -> hits + 1
        {:nok, _} -> hits
      end
    end)
  end

  def run() do
    {lower, higher} = decode_input(@input)
    count_in_range(lower..higher)
  end

  #
  # Part #2
  #

  def is_check_double?(true, _hits, digits), do: {:ok, digits}
  def is_check_double?(_found, 2, digits), do: {:ok, digits}
  def is_check_double?(_found, _hits, digits), do: {:nok, digits}

  def check_strict_double({:ok, digits}) do
    {{found, hits}, _} = 
    digits
    |> Enum.reduce({{false, 1}, -1}, fn(digit, {{found, hits}, prev}) ->
      {found, new_hits} = 

      if found || (hits == 2 && prev != digit) do
        {true, hits}
      else
        if prev == digit do
          {found, hits + 1}
        else
          {found, 1}
        end
      end
      {{found, new_hits}, digit}
    end)

    is_check_double?(found, hits, digits)
  end
  def check_strict_double(value), do: value

  def run_for_number_2(number) do
    digits =
    number
    |> Tools.split_number_into_digits()

    {:ok, digits}
    |> check_decrease()
    |> check_strict_double()
  end

  def count_in_range_2(numbers) do
    numbers
    |> Enum.reduce(0, fn(number, hits) -> 
      case run_for_number_2(number) do
        {:ok, _} -> hits + 1
        {:nok, _} -> hits
      end
    end)
  end

  def run_2() do
    {lower, higher} = decode_input(@input)
    count_in_range_2(lower..higher)
  end
end
