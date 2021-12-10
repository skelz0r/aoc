# frozen_string_literal: true

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split.map { |seq| seq.split('').map(&:to_i) }

oxygen_generator_acc = data.dup
co2_scrubber_rating_acc = data.dup

data[0].count.times do |i|
  one_count = oxygen_generator_acc.map { |bin| bin[i] }.count(1)

  if one_count >= oxygen_generator_acc.count/2.0
    oxygen_generator_acc.delete_if { |bin| bin[i] == 0 }
  else
    oxygen_generator_acc.delete_if { |bin| bin[i] == 1 }
  end

  break if oxygen_generator_acc.one?
end

data[0].count.times do |i|
  one_count = co2_scrubber_rating_acc.map { |bin| bin[i] }.count(1)

  if one_count < co2_scrubber_rating_acc.count/2.0
    co2_scrubber_rating_acc.delete_if { |bin| bin[i] == 0 }
  else
    co2_scrubber_rating_acc.delete_if { |bin| bin[i] == 1 }
  end

  break if co2_scrubber_rating_acc.one?
end

print co2_scrubber_rating_acc.join('').to_i(2) * oxygen_generator_acc.join('').to_i(2)
