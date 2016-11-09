defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  # Pattern match the image and grab first 3 values of the hex list
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      # group into list of list of 3 elements
      |> Enum.chunk(3)
      # map to new list with mirrored rows
      |> Enum.map(&mirror_row/1) #&func_name/argument number is passing a referrence of function
      # flatten nested lists
      |> List.flatten
      # creates a list of tuples with first elem the elem, second the index
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row

    # ++ is append to list operator
    row ++ [second, first]
  end
end
