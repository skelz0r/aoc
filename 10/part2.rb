# frozen_string_literal: true

require 'byebug'

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n")

@open_chars = ['<', '{', '[', '(']
@closed_chars = ['>', '}', ']', ')']
incomplete_lines = []

data.each do |line|
  go_to_next_line = false
  opens = []
  chars = line.split('')

  chars.each_with_index do |char, char_index|
    break if go_to_next_line

    if @open_chars.include?(char)
      opens << char
    else
      index_closed = @closed_chars.index(char)
      valid_open = @open_chars[index_closed]

      if opens[-1] == valid_open
        opens.pop
      else
        go_to_next_line = true
      end
    end
  end

  unless go_to_next_line
    incomplete_lines << line
  end
end

def build_closed_chars(chars)
  chars.map do |c|
    @closed_chars[@open_chars.index(c)]
  end
end

completions = []

incomplete_lines.each do |line|
  opens = []
  chars = line.split('')

  chars.each_with_index do |char, char_index|
    if @open_chars.include?(char)
      opens << char
    else
      opens.pop
    end
  end

  closed = build_closed_chars(opens)
  completions <<  closed.reverse
end

tmp = completions.map do |completion|
  completion.reduce(0) do |acc, char|
    acc = acc*5

    c = case char
      when ')'
        1
      when ']'
        2
      when '}'
        3
      when '>'
        4
      end

    acc + c
  end
end

p tmp.sort[tmp.size/2]
