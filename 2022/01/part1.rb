# frozen_string_literal: true

result = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n\n").map do |group|
  group.split.map(&:to_i).reduce(:+)
end.max

p result
