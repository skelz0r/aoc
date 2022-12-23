require 'byebug'

file = ARGV[0].nil? ? 'input' : 'example'

def dprint(string)
  # print string
end

@graph = {}
@min_x = @min_y = @max_x = @max_y = 0

File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n").each_with_index do |line, y|
  @max_y = y

  line.split('').each_with_index do |char, x|
    @max_x = x

    @graph["#{x},#{y}"] = char
  end
end

def print_graph
  offset = 0
  (@min_y+1-offset..@max_y+offset).each do |y|
    (@min_x+1-offset..@max_x+offset).each do |x|
      dprint @graph["#{x},#{y}"] || '.'
    end

    dprint "\n"
  end
end

def no_elfes_around?(x,y)
  [
    @graph["#{x-1},#{y-1}"],
    @graph["#{x},#{y-1}"],
    @graph["#{x+1},#{y-1}"],
    @graph["#{x-1},#{y+1}"],
    @graph["#{x},#{y+1}"],
    @graph["#{x+1},#{y+1}"],
    @graph["#{x-1},#{y}"],
    @graph["#{x+1},#{y}"],
  ].none? { |c| c == '#' }
end

def get_potential_direction_for_elfe(x, y, i)
  potential_directions = [
    [@graph["#{x-1},#{y-1}"], @graph["#{x},#{y-1}"], @graph["#{x+1},#{y-1}"]].all? { |c| c != '#' } ? 'N' : nil,
    [@graph["#{x-1},#{y+1}"], @graph["#{x},#{y+1}"], @graph["#{x+1},#{y+1}"]].all? { |c| c != '#' } ? 'S' : nil,
    [@graph["#{x-1},#{y+1}"], @graph["#{x-1},#{y}"], @graph["#{x-1},#{y-1}"]].all? { |c| c != '#' } ? 'W' : nil,
    [@graph["#{x+1},#{y+1}"], @graph["#{x+1},#{y}"], @graph["#{x+1},#{y-1}"]].all? { |c| c != '#' } ? 'E' : nil,
  ]

  potential_directions.rotate(i).compact.first
end

dprint "Initial graph:\n"
print_graph

i = 0

loop do
  @elfes = {}

  # Step 1
  @graph.each do |xy, value|
    x, y = xy.split(',').map(&:to_i)

    if value == '#'
      next if no_elfes_around?(x, y)

      potential_direction = get_potential_direction_for_elfe(x, y, i)

      next unless potential_direction

      case potential_direction
      when 'N'
        @min_y = y-1 if y-1 < @min_y
        @elfes[xy] = "#{x},#{y-1}"
      when 'S'
        @max_y = y+1 if y+1 > @max_y
        @elfes[xy] = "#{x},#{y+1}"
      when 'W'
        @min_x = x-1 if x-1 < @min_x
        @elfes[xy] = "#{x-1},#{y}"
      when 'E'
        @max_x = x+1 if x+1 > @max_x
        @elfes[xy] = "#{x+1},#{y}"
      end
    end
  end

  # Step 2
  @elfes.values.select do |new_position|
    @elfes.values.count(new_position) > 1
  end.uniq.each do |new_position_to_delete|
    @elfes.delete_if { |_, v| v == new_position_to_delete }
  end

  if @elfes.empty?
    print i+1
    break
  else
    print "#{i+1} iteration\n"
  end

  @elfes.each do |old_position, new_position|
    @graph[new_position] = '#'
    @graph[old_position] = '.'
  end

  dprint "\n"
  dprint "After #{i+1} iteration:\n"
  print_graph
  i+=1
end
