require 'byebug'

file = ARGV[0].nil? ? 'input' : 'example'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n")

def dprint(string)
  print string
end

@graph = {}

@minx = 1*Float::INFINITY
@maxx = -1*Float::INFINITY
@miny = 0
@maxy = 0

def change_min_max(from, to)
  current_minx = [from[0], to[0]].min
  @minx = current_minx if current_minx < @minx

  current_maxx = [from[0], to[0]].max
  @maxx = current_maxx if current_maxx > @maxx

  current_maxy = [from[1], to[1]].max
  @maxy = current_maxy if current_maxy > @maxy
end

@data.each do |line|
  nodes = line.split(' -> ')

  nodes.each_with_index do |node, index|
    break if index == nodes.length - 1

    from = node.split(',').map(&:to_i)
    to = nodes[index + 1].split(',').map(&:to_i)

    if from[0] == to[0]
      range = from[1] < to[1] ? (from[1]..to[1]) : (to[1]..from[1])

      change_min_max(from, to)

      range.each do |y|
        @graph[[from[0], y]] ||= '#'
      end
    else
      range = from[0] < to[0] ? (from[0]..to[0]) : (to[0]..from[0])

      change_min_max(from, to)

      range.each do |x|
        @graph[[x, from[1]]] ||= '#'
      end
    end
  end
end

dprint "[Dimension] minx: #{@minx}, maxx: #{@maxx}, miny: #{@miny}, maxy: #{@maxy}\n"

@maxy += 2
@minx -= 10_000
@maxx += 10_000

(@minx..@maxx).each do |x|
  (@miny..@maxy).each do |y|
    @graph[[x, y]] ||= '.'
  end
end

(@minx..@maxx).each do |x|
  @graph[[x, @maxy]] = '#'
end

@graph[[500, 0]] = '+'

def print_graph
  (@miny..@maxy).each do |y|
    (@minx..@maxx).each do |x|
      print @graph[[x, y]]
    end
    print "\n"
  end
end

def add_sand
  current_sand_position = [500, 0]

  loop do
    next_y_blocked = @graph[[current_sand_position[0], current_sand_position[1]+1]] != '.'
    left_down_x_is_blocked = @graph[[current_sand_position[0]-1, current_sand_position[1]+1]] != '.'
    right_down_x_is_blocked = @graph[[current_sand_position[0]+1, current_sand_position[1]+1]] != '.'

    if !next_y_blocked
      current_sand_position[1] += 1
    elsif !left_down_x_is_blocked
      current_sand_position[0] -= 1
      current_sand_position[1] += 1
    elsif !right_down_x_is_blocked
      current_sand_position[0] += 1
      current_sand_position[1] += 1
    else
      return false if current_sand_position == [500, 0]

      break
    end
  end

  @graph[current_sand_position] = 'o'

  true
end

i = 1

loop do
  break unless add_sand

  i += 1
end

print i
