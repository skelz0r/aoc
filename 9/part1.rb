# frozen_string_literal: true

require 'byebug'

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").map { |line| line.split('').map(&:to_i) }

lowest_points = []

data.each_with_index do |line, i|
  line.each_with_index do |nb, j|
    next unless (i == 0 || data[i-1][j] > nb) &&
      (i == data.length-1 || data[i+1][j] > nb) &&
      (j == 0 || data[i][j-1] > nb) &&
      (j == data[i].length-1 || data[i][j+1] > nb)

		p "#{nb}: #{i},#{j}"
    lowest_points << nb
  end
end

p lowest_points.map { |i| i+1 }.sum
