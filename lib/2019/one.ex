defmodule AdventOfCode.Y2019.One do
  alias AdventOfCode.Tools
  
  #
  # Part #1
  #

  def compute(mass) when mass < 6, do: 0
  def compute(mass) do
    floor(mass / 3) - 2
  end

  def compute_all(masses) do
    masses
    |> Enum.reduce(0, fn(x, acc) -> compute(x) + acc end)
  end

  def run() do
    Tools.read_int_lines_from_console()
    |> compute_all()
    |> IO.inspect(label: "Result")
  end

  #
  # Part #2
  #

  def compute_fuel_4_fuel(fuel_mass, total) when fuel_mass < 6, do: total
  def compute_fuel_4_fuel(fuel_mass, total) do
    compute_2(fuel_mass, total)
  end

  def compute_2(mass, total \\ 0) do
    fuel_mass = compute(mass)
    fuel_mass + compute_fuel_4_fuel(fuel_mass, total)
  end

  def compute_all_2(masses) do
    masses
    |> Enum.reduce(0, fn(x, acc) -> compute_2(x) + acc end)
  end

  def run_2() do
    Tools.read_int_lines_from_console()
    |> compute_all_2()
    |> IO.inspect(label: "Result")
  end
end
