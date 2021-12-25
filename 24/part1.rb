# frozen_string_literal: true

require 'byebug'

file = 'input'
@should_debug = true

@instructions = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt",
  )
).split("\n").reject do |line|
  line.size == 0
end

def debug(string)
  return unless @should_debug

  print string
  print "\n"
end

def var_or_value(vars, text)
  if vars.keys.include?(text)
    vars[text]
  else
    text.to_i
  end
end

def execute(instructions, initial_value, vars = nil)
  vars ||= {
    'w' => 0,
    'x' => 0,
    'y' => 0,
    'z' => 0,
  }
  value = initial_value.to_s.split('').map { |c| c.to_i }.reverse

  instructions.each_with_index do |instruction, i|
    kind, *elements = instruction.split(" ")

    begin
    case kind
    when 'inp'
      value_to_affect = value.pop
      vars[elements[0]] = value_to_affect
    when 'add'
      vars[elements[0]] += var_or_value(vars, elements[1])
    when 'mul'
      vars[elements[0]] *= var_or_value(vars, elements[1])
    when 'div'
      vars[elements[0]] = vars[elements[0]] / var_or_value(vars, elements[1])
    when 'mod'
      vars[elements[0]] = vars[elements[0]] % var_or_value(vars, elements[1])
    when 'eql'
      vars[elements[0]] = vars[elements[0]] == var_or_value(vars, elements[1]) ? 1 : 0
    end
    rescue => e
      byebug
    end

    # debug("Step #{i+1}: #{vars}")
  end

  vars
end

# max = 99_999_999_999_999
# @maxz = 0
# i = 0
#
# value = max - 10_000_000_000_000
#
# loop do
#   value -= 1
#
#   next if value.to_s.include?('0')
#   break if i > 1_000_000
#
#   i += 1
#   p i if i % 10_000 == 0
#
#   vars = execute(@instructions, value)
#
#   if vars['z'] > @maxz
#     p @maxz
#     @maxz = vars['z']
#   end
# end

# vars = {
#   'w' => 0,
#   'x' => 0,
#   'y' => 0,
#   'z' => 0,
# }
#
# add_x = %i[
#   11
#   14
#   15
#   13
#   -12
#   10
#   -15
#   13
#   10
#   -13
#   -13
#   -14
#   -2
#   -9
# ]
#
# byebug
#
# @instructions.each_slice(18).each_with_index do |step_instructions, i|
#   acc = []
#
#   (1..9).each do |w|
#     vars = {
#       'w' => w,
#       'x' => i,
#       'y' => i,
#       'z' => i,
#     }
#
#     vars = execute(step_instructions, w, vars)
#
#     p vars
#     if vars['z'] == 0
#       acc << vars
#     end
#   end
#   break
#
#   print "Step #{i+1}: #{acc.count}\n"
# end
#
# exit
#
# acc = []
# first_half_range = (1..9).to_a.repeated_permutation(7)
#
# @minz = Float::INFINITY
#
# first_half_range.each do |value|
#   vars = execute(@instructions.each_slice(2).first, value.join)
#
#   p value
#   if vars['z'] != 0
#     byebug
#   end
# end
#
# exit
#
# @instructions.each_slice(18).each_with_index do |step_instructions, i|
#   all = (1..9).map do |i|
#     [i, execute(step_instructions, i.to_s, vars.dup)]
#   end.sort do |v1, v2|
#     v1[1]['z'] <=> v2[1]['z']
#   end
#
#   best = all.first
#
#   acc << best[0]
#   vars = best[1]
# end
#
# p acc, vars
#
# p execute(@instructions, acc.join)
#
# exit
#
# value = 99992979399143
# @minz = Float::INFINITY
#
# value = 99_992_996_943_286
# step_size = 10_000_000_000
# p execute(value)
#
# value = 19412996943286
# step_size = 1_000_000_000
#
# value = 1941299694328
# i = 0
# step_size = 1
#
# loop do
#   value -= step_size
#
#   next if value.to_s.include?('0')
#   break if value < 11_111_111_111_111
#
#   i += 1
#
#   vars = execute(@instructions, value)
#
#   if vars['z'] < @minz
#     @minz = vars['z']
#     p "New min"
#     p "Current status: #{value}"
#     p "Vars: #{vars}"
#   end
#
#   if vars['z'] == 0
#     p "WIN: #{value}"
#     p "Vars: #{vars}"
#     exit
#   end
#
#   if i % 100 == 0
#     p "Current status: #{value}"
#     p "Vars: #{vars}"
#   end
# end

stack = []

top = 99_999_999_999_999
bottom = 11_111_111_111_111

(0...14).each do |index|
  # l6 -> add x VALUE
  xadd = @instructions[(index * 18) + 5].split.last.to_i
  # l16 -> add y VALUE
  yadd = @instructions[(index * 18) + 15].split.last.to_i

  # x == w => z does not change
  if xadd > 0
    stack.push([yadd, index])
    next
  end

  yadd, prev_index = stack.pop

  exp = (xadd > -yadd) ? 13 - prev_index : 13 - index
  top -= ((xadd + yadd) * 10 ** exp).abs

  exp = (xadd < -yadd) ? 13 - prev_index : 13 - index
  bottom += ((xadd + yadd) * 10 ** exp).abs
end

p top,bottom
