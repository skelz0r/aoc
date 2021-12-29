# frozen_string_literal: true

require 'byebug'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split

def to_range(string)
  l,r=string.split('..')
  (l.to_i..r.to_i)
end

@xr = to_range(@data[2].sub(',', '')[2..])
@yr = to_range(@data[3][2..])

print "Area: #{@xr}, #{@yr}\n"

def move(coords)
  cx,cy = coords

  cx += @vx
  cy += @vy

  if cy > @chy
    @chy = cy
  end

  @vy -=1

  if @vx > 0
    @vx -= 1
  elsif @vx < 0
    @vx += 1
  end

  [cx,cy]
end

@cvx,@cvy = [@xr.last*10, (@yr.last*-1)*10]
@hy = 0

loop do
  coords = [0,0]

  @chy = 0
  @vx = @cvx.dup
  @vy = @cvy.dup

  in_area = out_of_area = nil

  loop do
    coords = move(coords)

    in_area = @xr.include?(coords[0]) && @yr.include?(coords[1])
    out_of_area = coords[0] > @xr.max || coords[1] < @yr.min

    break if in_area || out_of_area
  end

  if in_area && @chy > @hy
    @hy = @chy.dup
  end

  if in_area || out_of_area
    if @cvx == 0
      @cvx = @xr.last
      @cvy -= 1
    else
      @cvx -=1
    end

    break if @cvy < @yr.first

    next
  end
end

print @hy
