defmodule AdventOfCode.Y2019.One do
  alias AdventOfCode.Tools
  
  def compute(mass) when mass <= 0, do: 0
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
end
