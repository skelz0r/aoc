file = 'input.txt'
input = File.read!(Path.join(Path.dirname(__ENV__.file), file))
lines = String.split(input)

replacements = %{
  "one" => "one1one",
  "two" => "two2two",
  "three" => "three3three",
  "four" => "four4four",
  "five" => "five5five",
  "six" => "six6six",
  "seven" => "seven7seven",
  "eight" => "eight8eight",
  "nine" => "nine9nine",
}

convert_string_to_digit = fn line ->
  Enum.reduce(replacements, line, fn {word, digit}, acc ->
    String.replace(acc, word, digit)
  end)
end

first_and_last_digit_combined = fn line ->
  matches = List.flatten(Regex.scan(~r/[0-9]/, line))

  fe = hd(matches)
  le = hd(Enum.reverse(matches))
  concat = fe <> le
  String.to_integer(concat)
end

true_numbers = Enum.map(lines, convert_string_to_digit)
numbers = Enum.map(true_numbers, first_and_last_digit_combined)

IO.puts(numbers |> Enum.sum)
