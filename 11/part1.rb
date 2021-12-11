# frozen_string_literal: true

require 'byebug'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").map do |line|
  line.split('').map do |c|
    c.to_i
  end
end

@flash_count = 0

def handle_point(x,y)
  return unless (0..9).include?(x) && (0..9).include?(y)
  return if @already_exploded.include?([x,y])

  @data[x][y] = @data[x][y] + 1

  if @data[x][y] == 10
    @data[x][y] = 0
    @already_exploded << [x,y]
    @flash_count += 1

    handle_point(x-1, y-1)
    handle_point(x-1, y)
    handle_point(x-1, y+1)

    handle_point(x, y-1)
    handle_point(x, y+1)

    handle_point(x+1, y-1)
    handle_point(x+1, y)
    handle_point(x+1, y+1)
  end
end

def print_data
  @data.each do |line|
    print "#{line.join('')}\n"
  end
  print "#{'='*10}\n"
end

100.times do |step|
  @already_exploded = []

  10.times do |x|
    10.times do |y|
      handle_point(x,y)
    end
  end

  print "Step: #{step+1}\n"
  print_data
end

p @flash_count
