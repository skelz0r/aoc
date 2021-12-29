# frozen_string_literal: true

numbers = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split.map(&:to_i)

result = numbers[1..].each_with_index.reduce(0) do |count, (number, i)|
  if number > numbers[i]
    count + 1
  else
    count
  end
end

print result
