require 'byebug'

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
)

trees = data.split("\n").map do |line|
  line.split('').map(&:to_i)
end

mh = trees.count
mw = trees[0].count

visible_count = 0

def tree_visible?(trees, x, y, mh, mw)
  tree = trees[y][x]
  line = trees[y]

  return true if line[0..x-1].max < tree
  return true if line[x+1..line.length-1].max < tree

  col = trees.inject([]) do |acc, line|
    acc << line[x]
  end

  return true if col[0..y-1].max < tree
  return true if col[y+1..col.length-1].max < tree

  false
end

(1..mh-2).each do |y|
  (1..mw-2).each do |x|
    visible_count += 1 if tree_visible?(trees, x, y, mh, mw)
  end
end

print (visible_count + mh*2 + mw*2 - 4)
