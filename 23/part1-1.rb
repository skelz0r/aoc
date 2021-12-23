# frozen_string_literal: true

require 'byebug'

file = 'input'

trap "SIGINT" do
  save_moves unless file == 'example'

  exit
end

def save_moves(nb=nil)
  nb ||= Time.now.to_i
  moves_file_name = "moves-#{nb}.txt"
  moves_file_path = File.join(File.dirname(__FILE__),
    moves_file_name,
  )

  File.open(moves_file_path, 'w') do |f|
    f.write(@moves)
  end
end

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt",
  )
).split("\n").map do |line|
  line.split('')
end

@grid = []

11.times do |i|
  @grid << [i+1, 1]
end

4.times do |i|
  @grid << [3+i*2, 2]
  @grid << [3+i*2, 3]
end

@score = 0

@pions = {
  'a1' => nil,
  'a2' => nil,
  'b1' => nil,
  'b2' => nil,
  'c1' => nil,
  'c2' => nil,
  'd1' => nil,
  'd2' => nil,
}

@steps_weight = {
  'a' => 1,
  'b' => 10,
  'c' => 100,
  'd' => 1000,
}

def print_grid
  pgrind = []

  5.times do
    pgrind << ['#']*13
  end

  @grid.each do |coords|
    pgrind[coords[1]][coords[0]] = '.'
  end

  @pions.each do |l, coords|
    pgrind[coords[1]][coords[0]] = l[0].upcase
  end

  print "  #{(0..9).to_a.join}\n"
  pgrind.each_with_index do |line, i|
    print "#{i} #{line.join}\n"
  end
end

def move_letter(letter, to_coords)
  from_coords = @pions[letter]
  @pions[letter] = to_coords

  steps_count = 0
  steps_count += (from_coords[0] - to_coords[0]).abs
  steps_count += (from_coords[1] - to_coords[1]).abs

  # Does not stop in the hallway
  if from_coords[1] != 1 && to_coords[1] != 1
    steps_count += 2
  end

  energy_used = steps_count*@steps_weight[letter[0]]
  print "Energy used: #{energy_used}\n"

  @score += energy_used
end

def win?
  @pions.all? do |l, coords|
    if l[0] == 'a'
      coords == [3,2] ||
        coords == [3,3]
    elsif l[0] == 'b'
      coords == [5,2] ||
        coords == [5,3]
    elsif l[0] == 'c'
      coords == [7,2] ||
        coords == [7,3]
    elsif l[0] == 'd'
      coords == [9,2] ||
        coords == [9,3]
    end
  end
end

%w[a b c d].each do |l|
  i = 1

  @grid.each do |coords|
    v = @data[coords[1]][coords[0]]

    if v == l.upcase
      @pions[l+i.to_s] = coords
      i += 1
    end
  end
end

if file == 'example'
  entries = [
    [3, [4,1]],
    [4, [7,2]],
    [6, [6,1]],
    [3, [5,3]],
    [7, [8,1]],
    [2, [5,2]],
    [1, [10,1]],
    [7, [9,3]],
    [6, [9,2]],
    [1, [3,2]]
  ].reverse
else
  if ARGV[0]
    moves_name = ARGV[0]
  else
    moves_name = 'moves-0.txt'
  end

  ARGV.clear

  # moves_name = 'moves-13372.txt'
  entries = eval(File.read(
    File.join(
      File.dirname(__FILE__),
      moves_name,
    )
  )).reverse
end

gets.clear

@moves = []

loop do
  print "\n\n"
  print_grid
  print "Current score: #{@score}\n\n"

  break if win?

  entry = entries.pop

  if entry
    position, coords = entry
    letter = @pions.keys[position]
    letter_coords = @pions.values[position]
  else
    print "Who moves ?\n"

    @pions.each_with_index do |(key,coords), i|
      print "[#{i}] #{key.upcase} (#{coords})\n"
    end

    position = nil

    loop do
      position = gets

      if position.chomp != ''
        position = position.chomp.downcase.to_i
      end

      break if (0..7).include?(position)

      print "Who moves ?\n"
    end

    letter = @pions.keys[position]
    letter_coords= @pions.values[position]

    coords = nil

    loop do
      print "Where ?\n"
      coords = gets

      coords = coords.chomp.split(',').map { |c| c.to_i }

      break if @grid.include?(coords)
    end
  end

  @moves << [@pions.keys.index(letter), coords]

  print "Letter #{letter} (#{letter_coords}) moves to #{coords}\n"
  move_letter(letter, coords)
end

save_moves(@score) unless file == 'example'
p "WIN"

