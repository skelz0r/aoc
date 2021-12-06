# frozen_string_literal: true

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split(',').map(&:to_i)

fishes = data
days = 80

days.times do
  new_fishes = []

  fishes.map! do |fish|
    if fish == 0
      new_fishes << 8
      6
    else
      fish -= 1
    end
  end

  fishes = fishes.concat(new_fishes)
end

print fishes.count
