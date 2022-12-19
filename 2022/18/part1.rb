require 'byebug'

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

def dprint(string)
  # print string
end

exposed_sides = @cubes.count*6

@cubes.each do |cube|
  (@cubes - [cube]).each do |another_cube|
    exposed_sides -= 1 if another_cube[0] == cube[0] && another_cube[1] == cube[1] && (another_cube[2] - cube[2]).abs == 1
    exposed_sides -= 1 if another_cube[1] == cube[1] && another_cube[2] == cube[2] && (another_cube[0] - cube[0]).abs == 1
    exposed_sides -= 1 if another_cube[2] == cube[2] && another_cube[0] == cube[0] && (another_cube[1] - cube[1]).abs == 1
  end
end

print exposed_sides
