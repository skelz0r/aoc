# frozen_string_literal: true

numbers = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split.map(&:to_i)

previous_compute = numbers[0..2].sum

result = numbers[2..].each_with_index.reduce(0) do |count, (_, i)|
  return count if numbers[i + 2].nil?

  current_compute = numbers[i..i + 2].sum

  r = if current_compute > previous_compute
        count + 1
      else
        count
      end

  previous_compute = current_compute

  r
end

print result
