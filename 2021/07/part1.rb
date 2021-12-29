# frozen_string_literal: true

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './example.txt'
  )
).split(',').map(&:to_i)

min, max = data.min, data.max

results = []

min.upto(max) do |i|
  tmp = data.dup

  tmp.map! do |v|
    (v - i).abs
  end

  # p "For #{i} => #{tmp.sum}"

  results << tmp.sum
end

p results.min
