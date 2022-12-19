require 'byebug'

# 2564
file = ARGV[0].nil? ? 'input' : 'example'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n")

@cubes = @data.map do |line|
  line.split(',').map(&:to_i)
end

@x_max = @cubes.map { |c| c[0] }.max + 1
@y_max = @cubes.map { |c| c[1] }.max + 1
@z_max = @cubes.map { |c| c[2] }.max + 1

def dprint(string)
  # print string
end

exposed_sides = []

@cubes.each do |cube|
  (@cubes - [cube]).each do |another_cube|
    if another_cube[0] == cube[0] && another_cube[1] == cube[1] && (another_cube[2] - cube[2]).abs == 1
    end

    exposed_sides -= 1 if another_cube[1] == cube[1] && another_cube[2] == cube[2] && (another_cube[0] - cube[0]).abs == 1
    exposed_sides -= 1 if another_cube[2] == cube[2] && another_cube[0] == cube[0] && (another_cube[1] - cube[1]).abs == 1
  end
end

print @cubes.count - exposed_sides.count
