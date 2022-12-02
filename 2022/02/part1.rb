# frozen_string_literal: true

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n")

# R, P, S

def score(a, b)
  if (b == 'X' && a == 'C') || (b == 'Y' && a == 'A') || (b == 'Z' && a == 'B')
    6
  elsif (b == 'X' && a == 'A') || (b == 'Y' && a == 'B') || (b == 'Z' && a == 'C')
    3
  else
    0
  end
end

def type(b)
  case b
  when 'X'
    1
  when 'Y'
    2
  else
    3
  end
end

sum = 0

data.each do |line|
  a,b = line.split
  sum += score(a,b) + type(b)
end

print sum
