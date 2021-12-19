# frozen_string_literal: true

require 'byebug'
require 'matrix'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n\n").map do |raw_scanner|
  raw_scanner_data = raw_scanner.split("\n")

  [
    raw_scanner_data[0].sub('--- scanner ', '').sub(' ---', '').to_i,
    raw_scanner_data[1..-1].map do |coords|
      Matrix[coords.split(',').map(&:to_i)]
    end
  ]
end.to_h

# Check https://www.euclideanspace.com/maths/algebra/matrix/transforms/examples/index.htm
@rotations = [
  Matrix[[1,0,0], [0,1,0], [0,0,1]],
  Matrix[[1,0,0], [0,0,-1], [0,1,0]],
  Matrix[[1,0,0], [0,-1,0], [0,0,-1]],
  Matrix[[1,0,0], [0,0,1], [0,-1,0]],

  Matrix[[0,-1,0], [1,0,0], [0,0,1]],
  Matrix[[0,0,1], [1,0,0], [0,1,0]],
  Matrix[[0,1,0], [1,0,0], [0,0,-1]],
  Matrix[[0,0,-1], [1,0,0], [0,-1,0]],

  Matrix[[-1,0,0], [0,-1,0], [0,0,1]],
  Matrix[[-1,0,0], [0,0,-1], [0,-1,0]],
  Matrix[[-1,0,0], [0,1,0], [0,0,-1]],
  Matrix[[-1,0,0], [0,0,1], [0,1,0]],

  Matrix[[0,1,0], [-1,0,0], [0,0,1]],
  Matrix[[0,0,1], [-1,0,0], [0,-1,0]],
  Matrix[[0,-1,0], [-1,0,0], [0,0,-1]],
  Matrix[[0,0,-1], [-1,0,0], [0,1,0]],

  Matrix[[0,0,-1], [0,1,0], [1,0,0]],
  Matrix[[0,1,0], [0,0,1], [1,0,0]],
  Matrix[[0,0,1], [0,-1,0], [1,0,0]],
  Matrix[[0,-1,0], [0,0,-1], [1,0,0]],

  Matrix[[0,0,-1], [0,-1,0], [-1,0,0]],
  Matrix[[0,-1,0], [0,0,1], [-1,0,0]],
  Matrix[[0,0,1], [0,1,0], [-1,0,0]],
  Matrix[[0,1,0], [0,0,-1], [-1,0,0]],
]

def calculate_distance(c1, c2)
  d1 = c1.to_a[0]
  d2 = c2.to_a[0]

  (d2[0] - d1[0]).abs +
    (d2[1] - d1[1]).abs +
    (d2[2] - d1[2]).abs
end

def overlap(rot_sj, si)
  (rot_sj & si).length >= 12
end

def apply_rot(rot, sj)
  sj.map do |coord|
    coord * rot
  end
end

s0 = @data[0]
handled = [0]
s_coords = [Matrix[[0,0,0]]]

loop do
  @data.each do |int, si|
    next if handled.include?(int)

    @rotations.each do |rot|
      break if handled.include?(int)
      # p "== Rotation #{rot}"
      rot_si = apply_rot(rot, si)

      s0.each do |c1|
        break if handled.include?(int)

        rot_si.each do |c2|
          break if handled.include?(int)

          offset = c1 - c2

          rot_si_with_offset = rot_si.dup.map do |cc2|
            cc2 + offset
          end

          if overlap(rot_si_with_offset, s0)
            handled << int
            p "Overlap: #{handled}"
            p offset
            s0 = s0.concat(rot_si_with_offset).uniq

            s_coords << offset
          end
        end
      end
    end
  end

  break if handled.sort == @data.keys.sort
end

p s_coords

distances = s_coords.permutation(2).map do |coords|
  calculate_distance(coords[0], coords[1])
end

p distances

p distances.max
