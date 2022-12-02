# frozen_string_literal: true

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n")

# R, P, S

def score(match)
  case match
  when :win
    6
  when :draw
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

def change_type(match, v)
  case match
  when :win
    case v
    when 'A'
      'Y'
    when 'B'
      'Z'
    else
      'X'
    end
  when :draw
    case v
    when 'A'
      'X'
    when 'B'
      'Y'
    else
      'Z'
    end
  when :loss
    case v
    when 'A'
      'Z'
    when 'B'
      'X'
    else
      'Y'
    end
  end
end

sum = 0

data.each do |line|
  a,b = line.split

  match = case b
  when 'Z'
    :win
  when 'Y'
    :draw
  else
    :loss
  end

  b = change_type(match, a)

  sum += score(match) + type(b)
end

print sum
