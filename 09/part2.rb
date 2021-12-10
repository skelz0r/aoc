# frozen_string_literal: true

require 'byebug'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").map { |line| line.split('').map(&:to_i) }

lowest_point_coordinates = []

@data.each_with_index do |line, i|
  line.each_with_index do |nb, j|
    next unless (i == 0 || @data[i-1][j] > nb) &&
      (i == @data.length-1 || @data[i+1][j] > nb) &&
      (j == 0 || @data[i][j-1] > nb) &&
      (j == @data[i].length-1 || @data[i][j+1] > nb)

    lowest_point_coordinates << [i,j]
  end
end

# @i=0

def location(u,v)
  return nil if @acc.include?([u,v])
  @acc << [u,v]

  return nil if u == -1 || u == @data.length
  return nil if v == -1 || v == @data[u].length

  # p "Inspect: #{u},#{v} (#{@data[u][v]})"
  # @i = @i + 1
  # exit if @i == 30

  return nil if @data[u][v] == 9

  [
    1,
    (location(u-1,v)),
    (location(u+1,v)),
    (location(u,v-1)),
    (location(u,v+1)),
  ].compact.flatten
end

basins_size = lowest_point_coordinates.map do |coordinates|
  i,j = coordinates

  # p "Init: #{coordinates}"
  @acc = []
  r = [
    1,
    location(i-1,j),
    location(i+1,j),
    location(i,j-1),
    location(i,j+1),
  ].compact.flatten.size-1
end

p basins_size

p basins_size.max(3).reduce(:*)
