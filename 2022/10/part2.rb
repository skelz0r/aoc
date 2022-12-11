require 'byebug'

instructions = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").map do |line|
  command, count = line.split(' ')

  [command, count.to_i]
end

to_add = Hash.new(0)
x = 1
cycle = 0

output = ''

def draw(x, i, output)
  if (x-1..x+1).include?(i % 40)
    output + '#'
  else
    output + '.'
  end
end

instructions.each do |instruction|
  x += to_add[cycle].dup

  last_cycle = cycle.dup

  case instruction[0]
  when 'addx'
    to_add[cycle + 2] += instruction[1].dup
    output = draw(x, cycle, output)
    output = draw(x, cycle+1, output)
    cycle += 2
  when 'noop'
    output = draw(x, cycle, output)
    cycle += 1
  end
end

6.times do |i|
  print output[i*40..(i+1)*40-1] + "\n"
end
