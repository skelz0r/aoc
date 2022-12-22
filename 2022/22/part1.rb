require 'byebug'

file = ARGV[0].nil? ? 'input' : 'example'

def dprint(string)
  # print string
end

@puzzle, @password = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n\n")

@puzzle = @puzzle.split("\n").map do |line|
  line.split('')
end
@max_y = @puzzle.length
@max_x = @puzzle.map { |line| line.length }.max

@puzzle.map do |line|
  if line.length < @max_x
    (line.length...@max_x).each do
      line << ' '
    end
  end
end

@password = @password.scan(/(\d+)(R|L)?/).map do |pair|
  [pair[0].to_i, pair[1]]
end

def print_puzzle
  @puzzle.each_with_index do |line, x|
    line.each_with_index do |char, y|
      if @coords == [x, y]
        case @direction
        when :right
          dprint '>'
        when :left
          dprint '<'
        when :up
          dprint '^'
        when :down
          dprint 'v'
        end
      else
        dprint char
      end
    end
    dprint "\n"
  end

  nil
end

@coords= [0,@puzzle[0].index('.')]
@direction = :right

def cycle_from_right
  [@puzzle[@coords[0]].index('.') || 9000, @puzzle[@coords[0]].index('#') || 9000].min
end

def cycle_from_left
 @max_x - [@puzzle[@coords[0]].reverse.index('.') || 9000, @puzzle[@coords[0]].reverse.index('#') || 9000].min - 1
end

def cycle_from_top
  @puzzle.reverse.each_with_index do |line, yy|
    next if line[@coords[1]] == ' '
    break @max_y - (yy + 1)
  end
end

def cycle_from_bottom
  @puzzle.each_with_index do |line, yy|
    next if line[@coords[1]] == ' '
    break yy
  end
end

def move
  case @direction
  when :right
    if (@coords[1] == @max_x - 1) || @puzzle[@coords[0]][@coords[1] + 1] == ' '
      next_x = cycle_from_right
    else
      next_x = @coords[1] + 1
    end

    return false if @puzzle[@coords[0]][next_x] == '#'

    @coords = [@coords[0], next_x]
  when :left
    if @coords[1] == 0 || @puzzle[@coords[0]][@coords[1] - 1] == ' '
      next_x = cycle_from_left
    else
      next_x = @coords[1] - 1
    end

    return false if @puzzle[@coords[0]][next_x] == '#'

    @coords = [@coords[0], next_x]
  when :up
    if @coords[0] == 0 || @puzzle[@coords[0] - 1][@coords[1]] == ' '
      next_y = cycle_from_top
    else
      next_y = @coords[0] - 1
    end

    return false if @puzzle[next_y][@coords[1]] == '#'

    @coords = [next_y, @coords[1]]
  when :down
    if @coords[0] == (@max_y - 1) || @puzzle[@coords[0] + 1][@coords[1]] == ' '
      next_y = cycle_from_bottom
    else
      next_y = @coords[0] + 1
    end

    return false if @puzzle[next_y][@coords[1]] == '#'

    @coords = [next_y, @coords[1]]
  end

  true
end

def rotate(rotation)
  case @direction
  when :right
    @direction = rotation == 'R' ? :down : :up
  when :left
    @direction = rotation == 'R' ? :up : :down
  when :up
    @direction = rotation == 'R' ? :right : :left
  when :down
    @direction = rotation == 'R' ? :left : :right
  end
end

while @password.any?
  next_move, next_rotation = @password.shift

  dprint "Current position: #{@coords}. Current direction: #{@direction}. Move #{next_move} step and rotate #{next_rotation}\n"
  print_puzzle

  next_move.times do
    next if move
    break
  end

  rotate(next_rotation) unless next_rotation.nil?
end

dprint "Finish\n"
print_puzzle

facing = case @direction
         when :right
           0
         when :down
           1
         when :left
           2
         when :up
           3
         end

print (@coords[0]+1)*1000+4*(@coords[1]+1)+facing
