# frozen_string_literal: true

require 'byebug'

file = 'input'
@should_debug = true

@map = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt",
  )
).split("\n").reject do |line|
  line.size == 0
end.map do |line|
  line.split('').select { |c| ['.', '>', 'v'].include?(c) }
end

def debug(string)
  return unless @should_debug

  print string
  print "\n"
end

def print_map(map)
  map.each do |line|
    print "#{line.join}\n"
  end
end

def move(coords, new_map)
  kind = @map[coords[1]][coords[0]]

  case kind
  when '.'
    return
  when '>'
    y = coords[1]
    x = (coords[0] == (@map[0].length - 1)) ? 0 : coords[0]+1

    # byebug

    if @map[y][x] == '.'
      @moved = true

      new_map[coords[1]][coords[0]] = '.'
      new_map[y][x] = kind
    end
  when 'v'
    x = coords[0]
    y = (coords[1] == (@map.length - 1)) ? 0 : coords[1]+1

    # byebug

    if @map[y][x] == '.'
      @moved = true

      new_map[coords[1]][coords[0]] = '.'
      new_map[y][x] = kind if new_map[y][x] == '.'
    end
  end
end

print_map(@map)

step = 0

loop do
  @moved = false

  ['>', 'v'].each do |kind|
    new_map = Marshal.load(Marshal.dump(@map.dup))

    new_map.each_with_index do |line, y|
      line.each_with_index do |_, x|
        point = @map[y][x]

        move([x,y], new_map) if point == kind
      end
    end

    @map = new_map
  end

  step += 1

  break unless @moved
end

p step
