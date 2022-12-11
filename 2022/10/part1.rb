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
strength_acc = 0
cycle = 0
cycle_completed = []

# instructions = [
#   ['noop', nil],
#   ['addx', 3],
#   ['addx', -5],
# ]

instructions.each do |instruction|
  x += to_add[cycle].dup

  last_cycle = cycle.dup

  case instruction[0]
  when 'addx'
    to_add[cycle + 2] += instruction[1].dup
    cycle += 2
  when 'noop'
    cycle += 1
  end

  if [20, 60, 100, 140, 180, 220].any? { |to_mark| (last_cycle..cycle).include?(to_mark) }
    ref_cycle = [20, 60, 100, 140, 180, 220].find { |to_mark| (last_cycle..cycle).include?(to_mark) }
    next if cycle_completed.include?(ref_cycle)

    cycle_completed << ref_cycle

    print "x: #{x} | cycle: #{ref_cycle} | strength: #{x*ref_cycle}\n"

    strength_acc += x*ref_cycle
  end
end

print strength_acc
