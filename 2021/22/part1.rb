require 'byebug'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './example.txt'
  )
).split("\n").map do |line|
  kind, ranges = line.split(' ')
  ranges = ranges.split(',').map do |range|
    l,r = range[2..].split('..')

    (l.to_i..r.to_i).to_a
  end

  [
    kind,
    ranges,
  ]
end

cubes = []

@data.each do |line|
  kind, ranges = line

  acc = []

  rangex = ([ranges[0].min, -50].max..[50,ranges[0].max].min)
  rangey = ([ranges[1].min, -50].max..[50,ranges[1].max].min)
  rangez = ([ranges[2].min, -50].max..[50,ranges[2].max].min)

  rangex.each do |x|
    rangey.each do |y|
      rangez.each do |z|
        acc << [x,y,z]
      end
    end
  end

  if kind == 'on'
    cubes = cubes.concat(acc).uniq
  else
    cubes = cubes - acc
  end
  p cubes.count
end

p cubes.count
