# class Range
#   def intersection(other)
#     return nil if (self.max < other.begin or other.max < self.begin)
#     [self.begin, other.begin].max..[self.max, other.max].min
#   end
#   alias_method :&, :intersection
#
#   def include?(r2)
#     self.include?(r2.min) && self.include?(r2.max)
#   end
# end

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
@maxxy = file == 'example' ? 20 : 4000000

@sensors = {}

def cal_distance(p1, p2)
  (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

@data.each do |line|
  p1,p2 = line.split(':')
  sx,sy = p1.match(/x=(\-?\d+), y=(\-?\d+)/).to_a[1..].map(&:to_i)
  bx,by = p2.match(/x=(\-?\d+), y=(\-?\d+)/).to_a[1..].map(&:to_i)

  @sensors[[sx, sy]] = cal_distance([sx, sy], [bx, by])
end

coords = []

def extract_sensors_for_line(x)
  @sensors.select do |sensor, distance|
    ((sensor[1] - distance)..(sensor[1] + distance)).include?(x)
  end
end

def extract_ranges_for_line(x, sensors)
  sensors.map do |sensor, distance|
    diffx = (sensor[0] - x).abs

    if (sensor[0] - (distance - diffx)) > (sensor[0] + (distance - diffx))
      rl = [0, (sensor[0] + (distance - diffx))].max
      rr = [@maxxy, (sensor[0] - (distance - diffx))].min
    else
      rl = [0, (sensor[0] - (distance - diffx))].max
      rr = [@maxxy, (sensor[0] + (distance - diffx))].min
    end

    rl..rr
  end
end

dprint "Sensors: #{@sensors}\n"

(0..@maxxy).each do |x|
  dprint "## Line #{x}\n" if file == 'example' || x % 100_000 == 0

  sensors = extract_sensors_for_line(x)
  ranges = extract_ranges_for_line(x, sensors)
  ranges = ranges.sort { |r1, r2| r2.size <=> r1.size }

  dprint "Ranges: #{ranges}\n" if file == 'example'

  final = ranges.map do |range|
    range.to_a
  end.reduce([]) do |acc, arr|
    acc.concat(arr)
    acc
  end.uniq

  dprint "Final: #{final.sort}\n" if file == 'example'

  if final.size < @maxxy+1
    coords = [x, (0..@maxxy).to_a.difference(final).first]
    break
  end
end

dprint "Coords: #{coords}\n"
print coords[0]*4000000 + coords[1]

