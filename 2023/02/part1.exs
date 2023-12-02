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
  @max_by_colors %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  def perform(path) do
    extract_lines(path)
    |> Enum.map(&format_line/1)
    |> Enum.filter(&valid_game/1)
    |> Enum.map(&game_number/1)
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

  defp valid_game(game) do
    rounds = game
      |> Map.values()
      |> hd()

    Enum.all?(rounds, &valid_round/1)
  end

  defp valid_round(round) do
    Enum.all?(round, &valid_color/1)
  end

  defp valid_color({color, count}) do
    count <= @max_by_colors[color]
  end

  defp game_number(game) do
    game
    |> Map.keys()
    |> hd()
  end
end

IO.puts(Day1P1.perform("input.txt"))
