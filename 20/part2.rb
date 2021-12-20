
require 'byebug'
require 'matrix'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n")

@algo = @data[0]
image = @data[2..].map do |l|
  l.split('')
end

def extend_image(image, size)
  image = Marshal.load(Marshal.dump(image.dup))
  xl = image[0].length + size*2

  image.each do |line|
    size.times do
      line = line.prepend('.')
      line = line.append('.')
    end
  end

  nl = ['.']*xl

  size.times do
    image = image.prepend(nl)
    image = image.append(nl)
  end

  image.map! do |line|
    line[0..xl-1]
  end

  image
end

def print_image(image)
  print "Image #{image[0].length}x#{image.length}\n"
  image.each do |l|
    print l.join('') + "\n"
  end
  print "\n"
end

def get_char(image, y, x, i)
  if image[y].nil?
    i % 2 == 1 ? '#' : '.'
  elsif image[y][x].nil?
    i % 2 == 1 ? '#' : '.'
  else
    image[y][x]
  end
end

def read_value(image, coords, i)
  x,y=coords

  binary = ''

  binary << get_char(image, y-1, x-1, i)
  binary << get_char(image, y-1, x, i)
  binary << get_char(image, y-1, x+1, i)
  binary << get_char(image, y, x-1, i)
  binary << get_char(image, y, x, i)
  binary << get_char(image, y, x+1, i)
  binary << get_char(image, y+1, x-1, i)
  binary << get_char(image, y+1, x, i)
  binary << get_char(image, y+1, x+1, i)

  binary.split('').map do |c|
    if c == '.'
      '0'
    else
      '1'
    end
  end.join.to_i(2)
end

image = extend_image(image, 50)

50.times do |i|
  new_image = Marshal.load(Marshal.dump(image))

  (image.length).times do |y|
    (image[0].length).times do |x|
      value = read_value(image, [x, y], i)

      tmp = new_image[y].dup
      tmp[x] = @algo[value]
      new_image[y] = tmp
    end
  end
  image = new_image
end

# print_image(image)

r = image.map do |line|
  line.count { |c| c == '#' }
end.sum

p r
