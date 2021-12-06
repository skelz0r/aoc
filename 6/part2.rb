# frozen_string_literal: true

require 'byebug'

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split(',').map(&:to_i)

fishes_data = data
days = 256

fishes = Array.new(0)
(0..8).to_a.each { |i| fishes[i] = fishes_data.count(i) }

days.times do |i|
  fishes = fishes.rotate
  fishes[6] += fishes[8]
end

p fishes.sum
