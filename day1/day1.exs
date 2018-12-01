defmodule Day1 do
  def decode(signal) do
    List.foldl(signal, 0, fn s, acc -> s + acc end)
  end
  def parseSignal(path) do
    rawString = File.read! path
    String.split(rawString, "\n")
      |> Enum.map(fn v -> String.to_integer(v) end)
  end

end

# Day1.decode([1,2,-6])
Day1.parseSignal("signal.txt")
  |> Day1.decode
  |> IO.inspect