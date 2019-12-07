defmodule AdventOfCode.Matrix do

  # builds a matrix
  def build(rows, cols, value \\ 0) do 
    for x <- 0..rows - 1, into: %{} do
      {x, (for y <- 0..cols - 1, into: %{}, do: {y, value})}
    end
  end

  # returns a new matrix with the given value changed
  def put(matrix, row, col, value) do

    new_col = 
    case matrix[row] do
      nil -> %{}
      the_row -> the_row
    end
    |> Map.put(col, value)

    matrix
    |> Map.put(row, new_col)

  end

  # Retrieves the value of the given position in the matrix or default if it does not exist
  def get(matrix, row, col, default \\ nil) do
    case matrix[row] do
      nil -> default
      the_row -> 
        case the_row[col] do
          nil -> default
          value -> value
        end
    end
  end

end