# frozen_string_literal: true

require 'byebug'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n")

@polymer = @data[0]

@pair_insertions = @data[2..-1].map do |pair_insertion|
  pair, char = pair_insertion.split(' -> ')

  [pair, char]
end.to_h

@single = @polymer.chars.tally
@pairs = @polymer.chars.each_cons(2).map(&:join).tally

40.times do |i|
  @pairs = @pairs.each_with_object(Hash.new(0)) do |(key, count), acc|
    acc[key[0] + @pair_insertions[key]] += count
    acc[@pair_insertions[key] + key[1]] += count

    @single[@pair_insertions[key]] ||= 0
    @single[@pair_insertions[key]] += count
  end
end

p @single.values.max - @single.values.min
