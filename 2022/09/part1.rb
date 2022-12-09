require 'byebug'

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").map do |line|
  direction, steps_count = line.split(' ')

  [direction, steps_count.to_i]
end

def move_h(h_pos, direction)
  case direction
  when 'U'
    h_pos[1] += 1
  when 'D'
    h_pos[1] -= 1
  when 'R'
    h_pos[0] += 1
  when 'L'
    h_pos[0] -= 1
  end

  h_pos
end

def move_t(h_pos, t_pos)
  return t_pos if (h_pos[0] - t_pos[0]).abs <= 1 && (h_pos[1] - t_pos[1]).abs <= 1

  if h_pos[0] == t_pos[0]
    if h_pos[1] > t_pos[1]
      t_pos[1] += 1
    else
      t_pos[1] -= 1
    end
  elsif h_pos[1] == t_pos[1]
    if h_pos[0] > t_pos[0]
      t_pos[0] += 1
    else
      t_pos[0] -= 1
    end
  else
    if h_pos[1] > t_pos[1]
      if h_pos[0] > t_pos[0]
        t_pos[0] += 1
        t_pos[1] += 1
      else
        t_pos[0] -= 1
        t_pos[1] += 1
      end
    else
      if h_pos[0] > t_pos[0]
        t_pos[0] += 1
        t_pos[1] -= 1
      else
        t_pos[0] -= 1
        t_pos[1] -= 1
      end
    end
  end

  t_pos
end

def print_map(h_pos, t_pos)
  (0..5).each do |y|
    (0..6).each do |x|
      if h_pos == [x, y]
        print 'H'
      elsif t_pos == [x, y]
        print 'T'
      else
        print '.'
      end
    end

    print "\n"
  end

  print "\n\n"
end

h_pos = [0, 0]
t_pos = [0, 0]

all_t_positions = []

i = 0

data.each do |direction, steps_count|
  # print "direction: #{direction}, steps_count: #{steps_count}\n"

  steps_count.times do
    h_pos = move_h(h_pos, direction)
    t_pos = move_t(h_pos, t_pos)

    all_t_positions << t_pos.dup
    # print_map(h_pos, t_pos)
  end
end

# print all_t_positions.uniq
# print "\n"
print all_t_positions.uniq.count
