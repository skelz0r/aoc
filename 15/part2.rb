# frozen_string_literal: true

require 'byebug'
require 'matrix'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n")

@map = @data.map do |line|
  line.split('').map { |c| c.to_i }
end

# x
@map.map do |line|
  lline = line.dup

  acc = line

  4.times do |i|
    nl = lline.map do |c|
      if c == 9
        1
      else
        c+1
      end
    end
    lline = nl

    acc = acc.concat(nl)
  end

  acc
end

# y
@s = @map.count

4.times do |i|
  @map.dup[i*@s..(i+1)*@s].each do |line|
    nl = line.map do |c|
      if c == 9
        1
      else
        c+1
      end
    end
    @map << nl
  end
end

@data2 = File.read(
  File.join(
    File.dirname(__FILE__),
    './exemple-expand.txt'
  )
).split("\n")

@map2 = @data2.map do |line|
  line.split('').map { |c| c.to_i }
end

@graph = {}

@mx,@my = [@map.length, @map[0].length]
@infinity = Float::INFINITY

@mx.times do |x|
  @my.times do |y|
    @graph["#{x},#{y}"] = @infinity
  end
end

@graph['0,0'] = 0
@graph['0,1'] = @map[0][1]
@graph['1,0'] = @map[1][0]
@processed = ['0,0']

def find_mini(graph)
  mini = @infinity
  node = nil

  @graph.each do |xy, value|
    if value < mini
      mini = value
      node = xy
    end
  end

  node
end

def voisins(xy)
  x,y = xy.split(',').map { |i| i.to_i }
  acc = []

  acc << "#{x-1},#{y}" if x > 0
  acc << "#{x+1},#{y}" if x < @mx-1
  acc << "#{x},#{y-1}" if y > 0
  acc << "#{x},#{y+1}" if y < @my-1

  acc
end

node = find_mini(@graph)

while node
  value = @graph[node]

  voisins(node).each do |coord|
    next if @graph[coord].nil?
    x,y = coord.split(',').map { |i| i.to_i }

    new_cost = value + @map[x][y]

    if @graph[coord] > new_cost
      @graph[coord] = new_cost
    end
  end

  @graph.delete(node)

  break if @graph["#{@mx-1},#{@my-1}"] < Float::INFINITY

  node = find_mini(@graph)
end

p @graph["#{@mx-1},#{@my-1}"]
