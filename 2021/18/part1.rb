# frozen_string_literal: true

require 'byebug'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n")

def add(pair1, pair2)
  [
    pair1,
    pair2,
  ]
end

def deep_get(positions)
  eval("@current_pair#{accessor(positions)}").dup
end

def deep_set(positions, v)
  eval("@current_pair#{accessor(positions)} = #{v}")
  p "After set #{@current_pair}"
end

def accessor(positions)
  positions.map { |i| "[#{i}]" }.join
end

def replace_left_value(v, positions)
  positions.pop

  return if positions.uniq == [0]

  p "Will add #{v} on the left of #{positions}"

	positions = (positions.join.to_i(2) - 1).to_s(2).split('').map(&:to_i)
  while positions.length < 4
    positions = [0] + positions
  end

  while deep_get(positions[0..positions.length-2]).is_a?(Integer)
    positions.pop
  end

  cv = deep_get(positions)

  if cv.is_a?(Array)
    positions << 0
    cv = deep_get(positions)
  end

  deep_set(positions, cv + v)
rescue
  byebug
end

def replace_right_value(v, positions)
  positions.pop

  return if positions.uniq == [1]

  p "Will add #{v} on the right of #{positions}"

	positions = (positions.join.to_i(2) + 1).to_s(2).split('').map(&:to_i)
  while positions.length < 4
    positions = [0] + positions
  end

  while deep_get(positions[0..positions.length-2]).is_a?(Integer)
    positions.pop
  end

  cv = deep_get(positions)

  if cv.is_a?(Array)
    positions << 0
    cv = deep_get(positions)
  end

  deep_set(positions, cv + v)
rescue
  byebug
end

def handle_explodes(positions)
  if positions.length > 4
    l,r = deep_get(positions[0..positions.length-2])
    return if r == nil || l == nil

    p "== Explode #{positions}: [#{l},#{r}]"

    @no_operation_made = false

    if r.is_a?(Array)
      handle_explodes(positions.dup << 1)
      return
    end

    if l.is_a?(Array)
      handle_explodes(positions.dup << 0)
      return
    end

    deep_set(positions[0..positions.length-2], 0)

    replace_left_value(l, positions.dup)
    replace_right_value(r, positions.dup)
  end

  if positions.empty?
    @current_pair.each_with_index do |pair, i|
      handle_explodes([i])
    end
  else
    current = deep_get(positions)

    return unless current.is_a?(Array)

    current.each_with_index do |pair, i|
      handle_explodes(positions.dup << i)
    end
  end
end

def handle_splits(positions)
  return unless @no_operation_made

  if positions.empty?
    @current_pair.each_with_index do |pair, i|
      handle_splits([i])
    end
  else
    current = deep_get(positions)

    if current.is_a?(Array)
      current.each_with_index do |pair, i|
        handle_splits(positions.dup << i)
      end
    elsif current > 9
      p "== Split #{current}"
      @no_operation_made = false

      new_v = [
        current/2,
        current/2 + current%2
      ]

      deep_set(positions, new_v)
    end
  end
end

def handle_actions
  loop do
    @no_operation_made = true

    handle_explodes([])
    handle_splits([]) if @no_operation_made

    break if @no_operation_made
  end
end

##################

# pair1 = '[[[[4,3],4],4],[7,[[8,4],9]]]'
# pair2 = '[1,1]'
#
# @current_pair = add(eval(pair1), eval(pair2))
#
# p "Start: #{@current_pair}"
#
# handle_actions
#
# p "End:      #{@current_pair}"
# p "Expected: #{[[[[0,7],4],[[7,8],[6,0]]],[8,1]]}"

####################

# @data = "[1,1]
# [2,2]
# [3,3]
# [4,4]
# [5,5]".split("\n")
# p @data

##################

@current_pair = eval(@data[0])

p "Start: #{@current_pair}"

i = 1

while @data[i]
  @current_pair = add(@current_pair, eval(@data[i]))
	p "==== Current pair: #{@current_pair}"
  handle_actions
  i += 1
  print "\n\n\n"
end

def compute_magnitude(pair)
  x,y = pair

  sx = if x.is_a?(Array)
    3*compute_magnitude(x)
  else
    3*x
  end

  sy = if y.is_a?(Array)
    2*compute_magnitude(y)
  else
    2*y
  end

  sx + sy
end

p compute_magnitude(@current_pair)
