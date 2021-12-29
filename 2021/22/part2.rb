require 'byebug'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").map do |line|
  kind, ranges = line.split(' ')
  ranges = ranges.split(',').map do |range|
    l,r = range[2..].split('..')

    (l.to_i..r.to_i).to_a
  end

  [
    kind,
    {
      'x' => ranges[0],
      'y' => ranges[1],
      'z' => ranges[2],
    }
  ]
end

#!/usr/bin/env ruby
# frozen_string_literal: true

class Cuboid
  attr_reader :left, :right, :bottom, :top, :front, :back

  def initialize(left, right, bottom, top, front, back)
    @left = left
    @right = right
    @bottom = bottom
    @top = top
    @front = front
    @back = back

    @removed = []
  end

  def width
    (right - left + 1).abs
  end

  def height
    (top - bottom + 1).abs
  end

  def depth
    (back - front + 1)
  end

  def volume
    width * depth * height - @removed.sum(&:volume)
  end

  def attach(range)
    Cuboid.new(
      left.attach(range),
      right.attach(range),
      bottom.attach(range),
      top.attach(range),
      front.attach(range),
      back.attach(range),
    )
  end

  def attach!(range)
    @left = left.attach range
    @right = right.attach range
    @bottom = bottom.attach range
    @top = top.attach range
    @front = front.attach range
    @back = back.attach range

    self
  end

  def intersects?(other)
    top >= other.bottom &&
      bottom <= other.top &&
      right >= other.left &&
      left <= other.right &&
      back >= other.front &&
      front <= other.back
  end

  def intersection(other)
    return nil unless intersects?(other)

    bottom = [@bottom, other.bottom].max
    top = [@top, other.top].min
    left = [@left, other.left].max
    right = [@right, other.right].min
    front = [@front, other.front].max
    back = [@back, other.back].min

    Cuboid.new(left, right, bottom, top, front, back)
  end

  def remove!(cuboid)
    @removed.each do |r|
      next unless r.intersects?(cuboid)
      r.remove!(cuboid.intersection(r))
    end

    @removed << cuboid
  end
end

reactor = []

@data.each do |kind, ranges|
  cuboid = Cuboid.new(
    ranges['x'].min,
    ranges['x'].max,
    ranges['y'].min,
    ranges['y'].max,
    ranges['z'].min,
    ranges['z'].max,
  )

  cuboides_intersecting = reactor.select do |another_cuboid|
    cuboid.intersects?(another_cuboid)
  end

  cuboides_intersecting.each do |another_cuboid|
    intersection = another_cuboid.intersection(cuboid)
    another_cuboid.remove!(intersection)
  end

  reactor << cuboid if kind == 'on'
end

puts reactor.sum(&:volume)
