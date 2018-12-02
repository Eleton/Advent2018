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

  def compareIds(a, b) do
    compareIds(String.graphemes(a), String.graphemes(b), 0, "")
  end
  
  def compareIds([], [], acc, common) do {acc, common} end
  def compareIds([a | aRest], [a | bRest], acc, common) do
    compareIds(aRest, bRest, acc, common <> a)
  end
  def compareIds([_ | aRest], [_ | bRest], acc, common) do
    compareIds(aRest, bRest, acc + 1, common)
  end

  def loop([id | ids]) do
    result = ids
      |> Enum.find(
        fn b ->
          {diff, _} = compareIds(id, b)
          case diff do
            1 -> true
            _ -> false
          end
        end
      )
    case result do
      nil -> loop(ids)
      foundId ->
        {_, remainingId} = compareIds(id, foundId)
        remainingId
    end
  end

end

Day2.parse("./ids.txt")
  |> Day2.loop
  |> IO.inspect

# Day2.compareIds("abcde", "axcye") |> IO.inspect