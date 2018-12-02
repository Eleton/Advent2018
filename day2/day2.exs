defmodule Day2 do
  def parse(path) do
    rawString = File.read!(path)
    String.split(rawString, "\n")
  end
  def idContains23(id) do
    values = String.split(id, "", trim: true)
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Map.values
    {
      Enum.member?(values, 2) |> booleanTo10,
      Enum.member?(values, 3) |> booleanTo10
    }
  end
  def decode(ids) do
    {twos, threes} = ids
    |> Enum.map(fn id -> idContains23(id) end)
    |> Enum.reduce({0, 0},
        fn {two, three}, {twoAcc, threeAcc} -> {two + twoAcc, three + threeAcc} end
      )
    twos*threes
  end
  def booleanTo10(bool) do
    case bool do
      true -> 1
      false -> 0
    end
  end
end

Day2.parse("./ids.txt")
  |> Day2.decode
  |> IO.inspect