defmodule Day3 do
  def parse(path) do
    rawString = File.read!(path)
    String.split(rawString, "\n")
      |> Enum.map(
        fn row ->
          [id, numbers] = String.split(row, "@")
          id = id |> String.trim("#") |> String.trim |> String.to_integer

          [coords, dimensions] = String.split(numbers, ":")

          [x, y] = String.split(coords, ",")
          x = x |> String.trim |> String.to_integer
          y = y |> String.trim |> String.to_integer

          [width, height] = String.split(dimensions, "x")
          width = width |> String.trim |> String.to_integer
          height = height |> String.trim |> String.to_integer

          {id, {x,y}, {width, height}}
        end
      )
  end

  def measure(pieces) do
    pieces
    |> Enum.reduce({0, 0},
      fn {_, {x,y}, {width, height}}, {xAcc, yAcc} ->
        xAcc = if x + width > xAcc, do: x + width, else: xAcc
        yAcc = if y + height > yAcc, do: y + width, else: yAcc
        {xAcc, yAcc}
      end
    )
  end

  def loop_pieces(result, []) do
    result
  end
  def loop_pieces(result, [piece | pieces]) do
    loop_piece(result, piece) |> loop_pieces(pieces)
  end

  def loop_piece(result, {_, {x, y}, {width, height}}) do
    loop_column(result, x+1, y+1, x+width, y+height)
  end

  def loop_column(result, x1, y, x2, y) do
    loop_row(result, x1, y, x2)
  end
  def loop_column(result, x1, y1, x2, y2) do
    loop_row(result, x1, y1, x2) |> loop_column(x1, y1+1, x2, y2)
  end

  def loop_row(result, x, y, x) do
    check(result, {x, y})
  end
  def loop_row(result, x1, y, x2) do
    check(result, {x1, y}) |> loop_row(x1+1, y, x2)
  end

  def check(result, coords) do
    case Map.has_key?(result, coords) do
      false -> Map.put(result, coords, 1)
      true -> Map.put(result, coords, result[coords] + 1)
    end
  end


  def find_correct(result, [piece | pieces]) do
    {id, {x, y}, {width, height}} = piece
    if loop_column2(result, x+1, y+1, x+width, y+height),
      do: id,
      else: find_correct(result, pieces)
  end

  def loop_column2(result, x1, y, x2, y) do
    if loop_row2(result, x1, y, x2),
      do: true,
      else: false
  end
  def loop_column2(result, x1, y1, x2, y2) do
    if loop_row2(result, x1, y1, x2),
      do: loop_column2(result, x1, y1+1, x2, y2),
      else: false
  end

  def loop_row2(result, x, y, x) do
    if check2(result, {x, y}),
      do: true,
      else: false
  end
  def loop_row2(result, x1, y, x2) do
    if check2(result, {x1, y}),
      do: loop_row2(result, x1+1, y, x2),
      else: false
  end

  def check2(result, coords) do
    if result[coords] == 1, do: true, else: false
  end
end

pieces = Day3.parse("input.txt")
Day3.loop_pieces(%{}, pieces)
  |> Day3.find_correct(pieces)
  |> IO.inspect