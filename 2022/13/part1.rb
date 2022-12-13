require 'byebug'

file = 'input'

@pairs = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n\n").map do |pairs|
  pairs.split("\n").map do |pair|
    eval(pair)
  end
end

def dprint(string)
  print string
end

def compare(p1, p2, i, d=0)
  tab = ' '*d

  dprint("#{tab}  Compare #{p1} and #{p2}\n")

  if p1.empty? && p2.empty?
    return :undefined
  end

  if p1.empty?
    dprint "#{tab}  No more item in left: right order\n"
    return true
  end

  if p2.empty?
    dprint "#{tab}  No more item in right: not right order\n"
    return false
  end
  if p1[0].is_a?(Integer) && p2[0].is_a?(Integer)
    dprint("#{tab}   Compare int #{p1[0]} and #{p2[0]}\n")
    case p1[0] <=> p2[0]
    when 0
      compare(p1[1..-1], p2[1..-1], i, d+1)
    when 1
      return false
    else
      return true
    end
  elsif p1[0].is_a?(Array) && p2[0].is_a?(Array)
    issue = compare(p1[0], p2[0], i, d+1)

    if issue == :undefined
      dprint("#{tab}  Undefined here, check next\n")

      compare(Array(p1[1]), Array(p2[1]), i, d+1)
    else
      issue
    end
  elsif p1[0].is_a?(Array) && p2[0].is_a?(Integer)
    compare(p1[0], [p2[0]], i, d+1)
  else
    compare([p1[0]], p2[0], i, d+1)
  end
end

sum = 0

@pairs.each_with_index do |pairs, i|
  p1, p2 = pairs

  dprint("# Pair #{i+1}\n")
  result = compare(p1, p2, i)

  if result == :undefined
    raise "Undefined"
  elsif result
    dprint(" Right order: #{i+1}")
    sum = (i+1) + sum
  else
    dprint(" Not right order")
  end

  dprint("\n")
end

print sum
