# frozen_string_literal: true

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
)

digits = data.split("\n").map do |l|
  l.split('|')[1].strip
end.join(' ').split

table = {
  0 => 'abcefg',
  1 => 'cf',
  2 => 'acdeg',
  3 => 'acdfg',
  4 => 'bcdf',
  5 => 'abdfg',
  6 => 'abdefg',
  7 => 'acf',
  8 => 'abcdefg',
  9 => 'abcdfg',
}

r = digits.select do |digit|
  [2, 4, 3, 7].include?(digit.length)
end

p r.count
