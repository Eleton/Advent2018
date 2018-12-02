defmodule Day1 do
  def decode(signal) do
    List.foldl(signal, 0, fn s, acc -> s + acc end)
  end
  def parseSignal(path) do
    rawString = File.read! path
    String.split(rawString, "\n")
      |> Enum.map(fn v -> String.to_integer(v) end)
  end

  def outerCalibrate(signal) do outerCalibrate(signal, 0, []) end

  def outerCalibrate(signal, frequency, frequencies) do
    case calibrate(signal, frequency, frequencies) do
      {frequency, frequencies} -> outerCalibrate(signal, frequency, frequencies)
      frequency -> frequency
    end
  end
  def calibrate([], frequency, frequencies) do
    {frequency, frequencies}
  end
  def calibrate([value | signal], frequency, frequencies) do
    newFrequency = value + frequency
    case Enum.member?(frequencies, newFrequency) do
      true -> newFrequency
      false -> calibrate(signal, newFrequency, [newFrequency | frequencies])
    end
  end

end

# Day1.decode([1,2,-6])
# Day1.parseSignal("signal.txt")
#   |> Day1.decode
#   |> IO.inspect

Day1.parseSignal("signal.txt")
  |> Day1.outerCalibrate
  |> IO.inspect