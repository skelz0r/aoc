require 'byebug'

file = 'input'

@map = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n").map { |line| line.split('') }

def dprint(string)
  # print string
end

def steps(char)
  case char
  when 'S'
    1
  when 'E'
    'z'.ord - 'a'.ord + 1
  else
    char.ord - 'a'.ord + 1
  end
end

def find_coords(char)
  @map.each_with_index do |line, y|
    line.each_with_index do |c, x|
      return [y, x] if c == char
    end
  end
end

@graph = {}

@mx,@my = [@map.length, @map[0].length]
@infinity = Float::INFINITY

@mx.times do |x|
  @my.times do |y|
    @graph["#{x},#{y}"] = @infinity
  end
end

start = find_coords('S')
finish = find_coords('E')

@graph[start.join(',')] = 1

def find_mini(graph)
  mini = @infinity
  node = nil

  @graph.each do |xy, value|
    if value < mini
      mini = value
      node = xy
    end
  end

  node
end

def climbable?(current_value, another_value)
  (current_value - another_value).abs <= 1 ||
    current_value > another_value
end

def voisins(xy)
  x,y = xy.split(',').map { |i| i.to_i }
  current_steps = steps(@map[x][y])
  acc = []

  acc << "#{x-1},#{y}" if x > 0 && climbable?(current_steps, steps(@map[x-1][y]))
  acc << "#{x+1},#{y}" if x < @mx-1 && climbable?(current_steps, steps(@map[x+1][y]))
  acc << "#{x},#{y-1}" if y > 0 && climbable?(current_steps, steps(@map[x][y-1]))
  acc << "#{x},#{y+1}" if y < @my-1 && climbable?(current_steps, steps(@map[x][y+1]))

  acc
end

node = find_mini(@graph)

while node
  value = @graph[node]

  voisins(node).each do |coord|
    next if @graph[coord].nil?

    new_cost = value + 1

    if @graph[coord] > new_cost
      @graph[coord] = new_cost
    end
  end

  @graph.delete(node)

  break if @graph[finish.join(',')] < Float::INFINITY

  node = find_mini(@graph)
end

p @graph[finish.join(',')] - 1
