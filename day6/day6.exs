defmodule Day6 do
  def parse(path) do
    rawString = File.read!(path)
    rawString
      |> String.split("\n")
      |> Enum.reduce({[], 1}, fn pair, {list, id} ->
        [x, y] = String.split(pair, ", ", trim: true)
        {[{id, {String.to_integer(x), String.to_integer(y)}} | list], id + 1}
      end)
      |> elem(0)
      |> Enum.reverse
  end

  def measure(coords) do
    coords |> Enum.reduce({0, 0}, fn {_, {x,y}}, {x_max, y_max} ->
      x_max = if x > x_max, do: x, else: x_max
      y_max = if y > y_max, do: y, else: y_max
      {x_max, y_max}
    end)
  end

  def create_grid({x, y}) do
    0..y
      |> Enum.map(
        fn y_value ->
          0..x
            |> Enum.map(fn x_value -> {x_value, y_value} end)
        end
      )
      |> List.flatten
  end

  def calculate_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def distances(coords, grid) do
    grid
      |> Enum.map(fn node ->
        {_, id} = coords
          |> Enum.reduce({10000, 0}, fn {id, coord}, {distance, closest_id} ->
            new_distance = calculate_distance(node, coord)
            cond do
              new_distance < distance -> {new_distance, id}
              new_distance > distance -> {distance, closest_id}
              new_distance == distance -> {distance, 0}
            end
          end)
        {id, node}
      end)
  end

  def get_infinities(grid, {width, height}) do
    grid
      |> Enum.filter(fn {_, {x, y}} ->
        x == 0 or y == 0 or x == width or y == height
      end)
      |> Enum.map(fn {id, _} -> id end)
      |> Enum.uniq
  end

  def remove_infinities(grid, infinities) do
    grid
      |> Enum.filter(fn {id, _} ->
        !Enum.member?(infinities, id)
      end)
  end

  def find_area(grid) do
    grid
      |> Enum.map(fn {id, _} -> id end)
      |> Enum.reduce(%{}, fn id, result ->
        Map.update(result, id, 1, &(&1 + 1))
      end)
      |> Map.to_list
      |> Enum.reduce(0, fn {_, area}, largest_area ->
        if area > largest_area, do: area, else: largest_area
      end)
      # |> Enum.map(fn m -> Map.to_list(m) end)
  end
end

input = Day6.parse("input.txt")
measure = Day6.measure(input)
grid = Day6.create_grid(measure)
  # |> IO.inspect

new_grid = input
  |> Day6.distances(grid)

infinities = new_grid
  |> Day6.get_infinities(measure)
  # |> IO.inspect

leftover = new_grid
  |> Day6.remove_infinities(infinities)
  |> Day6.find_area
  |> IO.inspect