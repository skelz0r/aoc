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

def view_length(tree, line)
  init = 1

  line.each do |another_tree|
    if tree > another_tree
      init += 1
    else
      return init
    end
  end

  init-1
end

def compute_scenic(trees, x, y, mh, mw)
  tree = trees[y][x]
  line = trees[y]

  lx = view_length(tree, line[0..x-1].reverse)
  rx = view_length(tree, line[x+1..line.length-1])

  col = trees.inject([]) do |acc, line|
    acc << line[x]
  end

  ty = view_length(tree, col[0..y-1].reverse)
  by = view_length(tree, col[y+1..col.length-1])

  print "lx: #{lx}, rx: #{rx}, ty: #{ty}, by: #{by}\n"

  lx*rx*ty*by
end

highest_scenic = 0

(1..mh-2).each do |y|
  (1..mw-2).each do |x|
    next unless tree_visible?(trees, x, y, mh, mw)

    tree_scenic = compute_scenic(trees, x, y, mh, mw)

    print "Tree (#{x+1}, #{y+1}) with high #{trees[y][x]} is visible and has #{tree_scenic} scenic points\n"

    highest_scenic = tree_scenic if tree_scenic > highest_scenic
  end
end

print highest_scenic
