defmodule NumberConverter do
  @replacements %{
    "one" => "one1one",
    "two" => "two2two",
    "three" => "three3three",
    "four" => "four4four",
    "five" => "five5five",
    "six" => "six6six",
    "seven" => "seven7seven",
    "eight" => "eight8eight",
    "nine" => "nine9nine"
  }

  def convert_string_to_digit(line) do
    Enum.reduce(@replacements, line, fn {word, digit}, acc ->
      String.replace(acc, word, digit)
    end)
  end

  def first_and_last_digit_combined(line) do
    matches = Regex.scan(~r/[0-9]/, line) |> List.flatten()

    fe = hd(matches)
    le = hd(Enum.reverse(matches))
    concat = fe <> le
    String.to_integer(concat)
  end

  def perform(file_path) do
    input =
      File.read!(Path.join(__DIR__, file_path))
      |> String.split()

    numbers =
      input
      |> Enum.map(&convert_string_to_digit/1)
      |> Enum.map(&first_and_last_digit_combined/1)

    Enum.sum(numbers)
  end
end

IO.puts(NumberConverter.perform("input.txt"))
