# frozen_string_literal: true

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split.map { |seq| seq.split('').map(&:to_i) }

gamma_rate = Array.new(data[0].count).map.with_index do |_, i|
  if data.select { |d| d[i] == 1 }.count > data.count/2
    1
  else
    0
  end
end

epsilon_rate = gamma_rate.map { |i| (i+1) % 2 }

print epsilon_rate.join('').to_i(2) * gamma_rate.join('').to_i(2)
