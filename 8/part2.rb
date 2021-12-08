# frozen_string_literal: true

require 'byebug'

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
)

final_data = data.split("\n").map do |line|
  parts = line.split("|")

  sequences = parts[0].split.map(&:strip)
  digits = parts[1].split.map(&:strip)

  mapping = ' ' * 7

  one = sequences.find { |seq| seq.length == 2 }
  four = sequences.find { |seq| seq.length == 4 }
  seven = sequences.find { |seq| seq.length == 3 }
  eight = sequences.find { |seq| seq.length == 7 }

  mapping[0] = seven.sub(one[0], '').sub(one[1], '')

  six = sequences.find do |seq|
    seq.length == 6 &&
      !(seq.include?(one[0]) && seq.include?(one[1]))
  end

  index_top_one = six.include?(one[0]) ? 1 : 0
  index_bottom_one = index_top_one == 1 ? 0 : 1

  mapping[2] = one[index_top_one]
  mapping[5] = one.sub(mapping[2], '')

  three = sequences.find do |seq|
    seq.length == 5 &&
      seq.include?(one[0]) &&
      seq.include?(one[1])
  end

  five = sequences.find do |seq|
    seq.length == 5 &&
      seq != three &&
      seq.include?(one[index_bottom_one])
  end

  two = sequences.find do |seq|
    seq.length == 5 &&
      seq != three &&
      seq != five
  end

  mapping[4] = (six.split('') - five.split('')).select { |i| i != one[index_top_one] }[0]

  nine = sequences.find do |seq|
    seq.length == 6 &&
      !seq.include?(mapping[4])
  end

  zero = sequences.find do |seq|
    seq.length == 6 &&
      seq != nine &&
      seq != six
  end

  nine = sequences.find do |seq|
    seq.length == 6 &&
      seq != zero &&
      seq != six
  end

  table = {
    zero => 0,
    one => 1,
    two => 2,
    three => 3,
    four => 4,
    five => 5,
    six => 6,
    seven => 7,
    eight => 8,
    nine => 9,
  }

  table = table.transform_keys do |key|
    key.chars.sort.join
  end

  digits.map do |digit|
    table[digit.chars.sort.join]
  end.join.to_i
end

p final_data.sum
