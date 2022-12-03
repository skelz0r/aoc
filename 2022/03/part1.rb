# frozen_string_literal: true

def intersection(s1, s2, s3)
  (s1.split('') & s2.split('') & s3.split(''))[0]
end

def weight(letter)
  if ('a'..'z').include?(letter)
    letter.ord - 96
  else
    letter.ord - 38
  end
end

count = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").each_slice(3).map do |lines|
  weight(
    intersection(*lines)
  )
end.reduce(:+)

print count
