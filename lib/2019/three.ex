defmodule AdventOfCode.Y2019.Three do
  alias AdventOfCode.Tools
  alias AdventOfCode.Matrix

  # The file containing the input data
  @filename "#{Path.dirname(__ENV__.file)}/three_input.txt"

  #
  # Part #1
  #

  defp get_cell_for_id(cell, id, acc, i) do
    # Let's chek if the cell already has the accumulator for this line
    case cell[id] do
      nil -> cell |> Map.put(id, acc + i)
      _ -> cell
    end
  end

  def walk({matrix, row, col, acc}, "U" <> str_step, id) do
    step = Tools.parse_integer(str_step)
    1..step
    |> Enum.reduce(matrix, fn(i, matrix) -> 
      cell = Matrix.get(matrix, row + i, col, %{})
      new_cell = get_cell_for_id(cell, id, acc, i)
      Matrix.put(matrix, row + i, col, new_cell)
    end)
    |> stop(row + step, col, acc + step)
  end

  def walk({matrix, row, col, acc}, "D" <> str_step, id) do
    step = Tools.parse_integer(str_step)
    1..step
    |> Enum.reduce(matrix, fn(i, matrix) -> 
      cell = Matrix.get(matrix, row - i, col, %{})
      new_cell = get_cell_for_id(cell, id, acc, i)
      Matrix.put(matrix, row - i, col, new_cell)
    end)
    |> stop(row - step, col, acc + step)
  end

  def walk({matrix, row, col, acc}, "R" <> str_step, id) do
    step = Tools.parse_integer(str_step)
    1..step
    |> Enum.reduce(matrix, fn(i, matrix) -> 
      cell = Matrix.get(matrix, row, col + i, %{})
      new_cell = get_cell_for_id(cell, id, acc, i)
      Matrix.put(matrix, row, col + i, new_cell)
    end)
    |> stop(row, col + step, acc + step)
  end

  def walk({matrix, row, col, acc}, "L" <> str_step, id) do
    step = Tools.parse_integer(str_step)
    1..step
    |> Enum.reduce(matrix, fn(i, matrix) -> 
      cell = Matrix.get(matrix, row, col - i, %{})
      new_cell = get_cell_for_id(cell, id, acc, i)
      Matrix.put(matrix, row, col - i, new_cell)
    end)
    |> stop(row, col - step, acc + step)
  end

  def stop(matrix, row, col, acc), do: {matrix, row, col, acc}

  def line_walk(id, line, dimensions \\ {%{}, 0, 0, 0})
  def line_walk(_id, [], dimensions), do: dimensions
  def line_walk(id, [h|t], dimensions) do
    line_walk(id, t, walk(dimensions, h, id))
  end

  def build_lines_matrix(lines) do
    lines
    |> Enum.reduce({%{}, 0}, fn(line, {matrix, line_id}) -> 
      {new_matrix, _row, _col, _acc} = line_walk(line_id, line, {matrix, 0, 0, 0})
      {new_matrix, line_id + 1}
    end)
    |> elem(0)
  end

  def select_crosses(matrix) do
    for {r, row} <- matrix do
      for {c, col} <- row do
      {r, c, col[0], col[1]}
      end
    end
    |> Enum.flat_map(fn(value) -> value end)
    |> Enum.filter(fn({_, _, line_1, line_2}) -> (line_1 != nil) && (line_2 != nil) end)
    |> Enum.map(fn({row, col, line_1, line_2}) -> {row, col, abs(row) + abs(col), line_1 + line_2} end)
  end

  def process_lines_by_distance(lines) do
    lines
    |> build_lines_matrix()
    |> select_crosses()
    |> Enum.sort(&(elem(&1, 2) <= elem(&2, 2)))
    |> List.first()
    |> elem(2)
  end


  def run() do
    Tools.read_list_from_file(@filename)
    |> process_lines_by_distance()
  end

  #
  # Part #2
  #

  def process_lines_by_speed(lines) do
    lines
    |> build_lines_matrix()
    |> select_crosses()
    |> Enum.sort(&(elem(&1, 3) <= elem(&2, 3)))
    |> List.first()
    |> elem(3)
  end

  def run_2() do
    Tools.read_list_from_file(@filename)
    |> process_lines_by_speed()
  end
end
