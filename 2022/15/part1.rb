require 'byebug'

file = ARGV[0].nil? ? 'input' : 'example'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n")

def dprint(string)
  print string
end

@count = 0
@row_to_analyze = file == 'example' ? 10 : 2000000

@graph = {}
@sensors = {}

@minx = 1*Float::INFINITY
@maxx = -1*Float::INFINITY
@miny = 1*Float::INFINITY
@maxy = -1*Float::INFINITY

def change_max_xy(x, y)
  @maxx = x if x > @maxx
  @maxy = y if y > @maxy

  @minx = x if x < @minx
  @miny = y if y < @miny
end

@data.each do |line|
  p1,p2 = line.split(':')
  sx,sy = p1.match(/x=(\-?\d+), y=(\-?\d+)/).to_a[1..].map(&:to_i)
  bx,by = p2.match(/x=(\-?\d+), y=(\-?\d+)/).to_a[1..].map(&:to_i)

  change_max_xy(sx, sy)
  change_max_xy(bx, by)

  @graph[[sx, sy]] = 'S'
  @graph[[bx, by]] = 'B'

  @sensors[[sx, sy]] = [bx, by]
end

to_add = file == 'example' ? 10 : 100
@minx -= to_add
@maxx += to_add
@miny -= to_add
@maxy += to_add

dprint "[Dimension] minx: #{@minx}, maxx: #{@maxx}, miny: #{@miny}, maxy: #{@maxy}\n"

def distance(p1, p2)
  (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

dprint "Build distances sensors\n"
@sensors.each do |sc, bc|
  max_distance = distance(sc, bc)
  dprint "> Handle sensor #{sc} with beacon #{bc}. Distance: #{max_distance}\n"

  xrange = (sc[0]-max_distance..sc[0]+max_distance)
  yrange = (sc[1]-max_distance..sc[1]+max_distance)

  next unless yrange.include?(@row_to_analyze)

  xrange.each do |x|
    if distance(sc, [x,@row_to_analyze]) <= max_distance && @graph[[x,@row_to_analyze]].nil?
      @graph[[x,@row_to_analyze]] = '#'
    end
  end
end

def print_graph
  (@miny..@maxy).each do |y|
    (@minx..@maxx).each do |x|
      print @graph[[x, y]] || '.'
    end
    print "\n"
  end
end

print_graph if file == 'example'

@graph.each do |pc, value|
  next unless pc[1] == @row_to_analyze

  @count += 1 if ['#', 'S'].include?(value)
end

print "\n\n"
print @count
