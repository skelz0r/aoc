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

def extract_biggest_sensor_to_jump(x, y)
  sensor_distance = [nil, -1*Float::INFINITY]

  @sensors.each do |sensor, sensor_distance_to_beacon|
    current_point_to_sensor_distance = cal_distance([x, y], sensor)

    next if current_point_to_sensor_distance > sensor_distance_to_beacon

    return [sensor, sensor_distance_to_beacon]
  end

  return sensor_distance
end

@data.each do |line|
  p1,p2 = line.split(':')
  sx,sy = p1.match(/x=(\-?\d+), y=(\-?\d+)/).to_a[1..].map(&:to_i)
  bx,by = p2.match(/x=(\-?\d+), y=(\-?\d+)/).to_a[1..].map(&:to_i)

  @sensors[[sx, sy]] = cal_distance([sx, sy], [bx, by])
end

@sensors = Hash[@sensors.sort_by { |k, v| k[1] }.to_a]

coords = []

(0..@maxxy).each do |x|
  dprint "## Line #{x}\n" if file == 'example' || x % 100_000 == 0
  y = 0

  loop do
    break if coords.length > 0
    break if y > @maxxy

    dprint "  Current: #{[x,y]}\n" if file == 'example'

    sensor, distance = extract_biggest_sensor_to_jump(x, y)

    if !distance.infinite?
      dprint "  Sensor used #{sensor} (#{distance} from beacon)\n" if file == 'example'

      diffx = (sensor[0] - x).abs

      to_jump = distance - diffx + 1

      if sensor[1] > y
        to_jump = to_jump + (sensor[1] - y)
      else
        to_jump = to_jump - (y - sensor[1])
      end

      y += to_jump

      dprint "  To jump: #{to_jump}, jump to #{y}\n" if file == 'example'
    else
      coords = [x,y]
    end
  end

  break if coords.length > 0
end

dprint "Coords: #{coords}\n"
print coords[0]*4000000 + coords[1]
