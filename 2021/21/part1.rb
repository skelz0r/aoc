require 'byebug'

p1p=3
p2p=7

# p1p=4
# p2p=8

p1s=0
p2s=0

d=0

loop do
  p1d=0
  p2d=0

  3.times do
    d += 1
    p1d += d
  end

  p1p = (p1p + p1d) % 10
  p1p = p1p == 0 ? 10 : p1p
  p1s += p1p

  break if p1s >= 1000

  3.times do
    d += 1
    p2d += d
  end

  p2p = (p2p + p2d) % 10
  p2p = p2p == 0 ? 10 : p2p
  p2s += p2p

  break if p2s >= 1000
end

p "P1: score #{p1s}"
p "P2: score #{p2s}"
p "Dice rolls #{d}"

if p1s >= 1000
  pf = p2s
else
  pf = p1s
end

p pf*d
