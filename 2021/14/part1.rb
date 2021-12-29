# frozen_string_literal: true

require 'byebug'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './example.txt'
  )
).split("\n")

@polymer = @data[0]

@pair_insertions = @data[2..-1].map do |pair_insertion|
  pair_insertion.split(' -> ')
end.freeze

p @polymer

4.times do |i|
  offset = 0

  (@polymer.length - 1).times do |i|
    break if @polymer[offset+i+1].nil?

    chars = @polymer[offset+i..offset+i+1]

    if valid_pair_insertion = @pair_insertions.find { |pair_insertion| pair_insertion[0] == chars }
      @polymer.insert(offset+i+1, valid_pair_insertion[1])
      offset += 1
    end
  end

  # valid_insertions = []
  #
  # @pair_insertions.each do |pair, new_char|
  #   if @polymer.include?(pair)
  #     valid_insertions << [pair, new_char]
  #   end
  # end
  #
  # valid_insertions.sort! do |pair_insertion|
  #   @polymer.index(pair_insertion[0])
  # end
  #
  # byebug if i ==
  #
  # valid_insertions.each_with_index do |(pair, new_char), index|
  #   offset = @polymer[index..].index(pair)
  #   byebug if offset.nil?
  #   @polymer.insert(offset+index+1, new_char)
  # end

  p "#{i}: #{@polymer}"
end

chars_count = @polymer.split('').group_by { |c| c }.transform_values { |v| v.count }

p chars_count
chars_count = chars_count.values

p chars_count.max - chars_count.min
