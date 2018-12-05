defmodule Day5 do
  def parse(path) do
    rawString = File.read!(path)
    rawString |> String.graphemes
  end

  def loop([a, b | graphemes]) do
    if String.downcase(a) == String.downcase(b) and a != b,
      do: loop(graphemes),
      else: [a | loop([b | graphemes])]
  end
  def loop(rest) do
    rest
  end

  def destroy(polymer) do
    new_polymer = loop(polymer)
    if length(new_polymer) == length(polymer),
      do: new_polymer,
      else: destroy(new_polymer)
  end

  def loop_through_letters(_, shortest, max, max) do
    shortest
  end
  def loop_through_letters(input, shortest, index, max) do
    length = input
      |> Enum.join("")
      |> String.to_charlist
      |> Enum.filter(fn c -> c != index and c != index + 32 end)
      |> List.to_string
      |> String.graphemes
      |> destroy
      |> length
    
    if length < shortest,
      do: loop_through_letters(input, length, index+1, max),
      else: loop_through_letters(input, shortest, index+1, max)
  end
end

Day5.parse("./mockup.txt")
  |> Day5.loop_through_letters(:infinity, 65, 91)
  |> IO.inspect