# frozen_string_literal: true

require 'byebug'

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n")

open_chars = ['<', '{', '[', '(']
closed_chars = ['>', '}', ']', ')']

corrupted = []

data.each do |line|
  go_to_next_line = false
  opens = []
  chars = line.split('')

  p "Line ##{data.index(line)+1}"

  chars.each_with_index do |char, char_index|
    break if go_to_next_line

    if open_chars.include?(char)
      opens << char
    else
      index_closed = closed_chars.index(char)
      valid_open = open_chars[index_closed]

      if opens[-1] == valid_open
        opens.pop
      else
        corrupted << char
        go_to_next_line = true
      end
    end
  end
end

tmp = corrupted.reduce(0) do |acc, char|
  acc += case char
  when ')'
    3
  when ']'
    57
  when '}'
    1197
  when '>'
    25137
  end
end

p tmp
