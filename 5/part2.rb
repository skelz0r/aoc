# frozen_string_literal: true

require 'byebug'
require 'matrix'

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").map do |line|
  line.split('->').map do |coord|
    coord.strip.split(',').map { |i| i.strip.to_i }
  end
end

valid_data = data

max_x = valid_data.map do |datum|
  datum[0]
end.flatten.max

max_y = valid_data.map do |datum|
  datum[1]
end.flatten.max

map = Matrix.build(max_x+1, max_y+1) { 0 }

valid_data.each do |datum|
  from, to = datum

  if from[0] == to[0]
    range = to[1] > from[1] ? (from[1]..to[1]) : (to[1]..from[1])

    range.each do |index|
      map[from[0], index] += 1
    end
  elsif from[1] == to[1]
    range = to[0] > from[0] ? (from[0]..to[0]) : (to[0]..from[0])

    range.each do |index|
      map[index, from[1]] += 1
    end
  else
    range_x = from[0]..to[0]
    range_y = from[1]..to[1]

    array_x = range_x.first > range_x.last ? range_x.first.downto(range_x.last).to_a : range_x.to_a
    array_y = range_y.first > range_y.last ? range_y.first.downto(range_y.last).to_a : range_y.to_a

    array_x.each_with_index do |x, i|
      map[x, array_y[i]] += 1
    end
  end
end

count_more_than_2 = map.inject(0) { |sum, i| i >= 2 ? sum+1 : sum }

# print map.transpose.to_a.map(&:inspect).join("\n")
p count_more_than_2
