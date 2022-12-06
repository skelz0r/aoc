ranges = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n").map do |line|
  line.split(',').map do |pair|
    tab = pair.split('-').map(&:to_i)
    (tab[0]..tab[1])
  end
end

count = ranges.count do |r|
  r[0].to_a & r[1].to_a != []
end

print count
