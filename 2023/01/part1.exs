file = 'input.txt'
input = File.read!(Path.join(Path.dirname(__ENV__.file), file))
lines = String.split(input)

first_and_last_digit_combined = fn line ->
  matches = List.flatten(Regex.scan(~r/[0-9]/, line))

  fe = hd(matches)
  le = hd(Enum.reverse(matches))
  concat = fe <> le
  String.to_integer(concat)
end

numbers = Enum.map(lines, first_and_last_digit_combined)

IO.puts(numbers |> Enum.sum)
