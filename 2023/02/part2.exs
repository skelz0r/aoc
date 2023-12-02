defmodule GameParser do
  def parse(input) do
    game_number =
      input
      |> String.split(~r/\s+/)
      |> Enum.at(1)
      |> String.slice(0..-2)
      |> String.to_integer()

    rounds =
      input
      |> String.split(": ")
      |> Enum.drop(1)
      |> hd
      |> String.split(";")
      |> Enum.map(&parse_round/1)

    %{game_number => rounds}
  end

  defp parse_round(round) do
    round
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_color_count/1)
  end

  defp parse_color_count(color_count) do
    [count_str, color] = String.split(String.trim(color_count), " ")
    count = String.to_integer(count_str)
    {color, count}
  end
end

defmodule Day1P1 do
  def perform(path) do
    extract_lines(path)
    |> Enum.map(&format_line/1)
    |> Enum.map(&minimum_balls/1)
    |> Enum.map(&extract_power/1)
    |> Enum.sum()
  end

  defp extract_lines(path) do
    File.read!(Path.join(__DIR__, path))
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
  end

  defp format_line(line) do
    GameParser.parse(line)
  end

  defp minimum_balls(game) do
    rounds = game
      |> Map.values()
      |> List.flatten()

    ["red", "green", "blue"]
    |> Enum.map(&max_count(&1, rounds))
  end

  defp max_count(color, rounds) do
    rounds
    |> Enum.filter(fn {c, _} -> c == color end)
    |> Enum.map(fn {_, count} -> count end)
    |> Enum.max()
  end

  defp extract_power(counts) do
    counts
    |> Enum.reduce(&(&1 * &2))
  end
end

IO.puts(Day1P1.perform("input.txt"))
