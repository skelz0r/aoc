# frozen_string_literal: true

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").map do |e|
  arr = e.split
  arr[1] = arr[1].to_i
  arr
end

final_coordinates = data.inject([0, 0, 0]) do |coordinates, action|
  case action[0]
  when 'forward'
    coordinates[0] += action[1]
    coordinates[1] += action[1]*coordinates[2]
  when 'up'
    coordinates[2] -= action[1]
  when 'down'
    coordinates[2] += action[1]
  end

  coordinates
end

print final_coordinates[0..1].reduce(:*)
