# frozen_string_literal: true

require 'matrix'
require 'byebug'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n")

def count_dots
  @grid.to_a.inject(0) do |acc, line|
    acc + line.count { |i| i > 0 }
  end
end

def print_grid(grid)
  grid.transpose.to_a.each do |line|
    print "#{line.join('')}\n"
  end
  print "#{'='*10}\n"
end

@dots = @data.select do |datum|
  datum.include?(',')
end.map do |datum|
  datum.split(',').map { |i| i.to_i }
end

@folds = @data.select do |datum|
  datum.include?('fold')
end.map do |datum|
  datum.sub('fold along ', '').split('=')
end

@max_x = @dots.map do |coords|
  coords[0]
end.max + 1

@max_y = @dots.map do |coords|
  coords[1]
end.max + 1

p "Grid size: #{@max_x},#{@max_y}"
@grid = Matrix.zero(@max_x, @max_y)

@dots.each do |coord|
  x,y = coord
  @grid[x, y] = 1
end

def make_fold(fold)
  kind, offset = fold

  if kind == 'y'
    @max_y = @max_y/2

    first_half = Matrix.zero(@max_x, @max_y)
    second_half = Matrix.zero(@max_x, @max_y)

    @max_x.times do |x|
      (@max_y).times do |y|
        first_half[x, y] = @grid[x,y]
        second_half[x, offset.to_i-1 - y] = @grid[x,y - offset.to_i]
      end
    end
  else
    @max_x = @max_x/2

    first_half = Matrix.zero(@max_x, @max_y)
    second_half = Matrix.zero(@max_x, @max_y)

    @max_x.times do |x|
      @max_y.times do |y|
        first_half[x, y] = @grid[x,y]
        second_half[offset.to_i-1 - x, y] = @grid[x - offset.to_i,y]
      end
    end
  end

  @grid = first_half+second_half
end

make_fold(@folds[0])

p count_dots
