# frozen_string_literal: true

require 'byebug'

## BUILD

file = 'example'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt",
  )
).split("\n").map do |line|
  line.split('')
end

@grid = []
@bottom_y = 5

11.times do |i|
  @grid << [i+1, 1]
end

4.times do |i|
  @grid << [3+i*2, 2]
  @grid << [3+i*2, 3]
  @grid << [3+i*2, 4]
  @grid << [3+i*2, 5]
end

pions = {
  'a1' => nil,
  'a2' => nil,
  'b1' => nil,
  'b2' => nil,
  'c1' => nil,
  'c2' => nil,
  'd1' => nil,
  'd2' => nil,

  'a3' => [7,4],
  'a4' => [9,3],

  'b3' => [5,4],
  'b4' => [7,3],

  'c3' => [5,3],
  'c4' => [9,4],

  'd3' => [3,4],
  'd4' => [3,3],

}

@steps_weight = {
  'a' => 1,
  'b' => 10,
  'c' => 100,
  'd' => 1000,
}

@final_col = {
  'a' => 3,
  'b' => 5,
  'c' => 7,
  'd' => 9,
}

%w[a b c d].each do |l|
  i = 1

  @grid.each do |coords|
    next if coords[1] > 3

    v = @data[coords[1]][coords[0]]

    if v == l.upcase
      pions[l+i.to_s] = coords[1] == 3 ? [coords[0], 5] : coords
      i += 1
    end
  end
end

def print_grid(pions)
  pgrind = []

  7.times do
    pgrind << ['#']*13
  end

  @grid.each do |coords|
    pgrind[coords[1]][coords[0]] = '.'
  end

  pions.each do |l, coords|
    pgrind[coords[1]][coords[0]] = l[0].upcase
  end

  print "  #{(0..9).to_a.join}\n"
  pgrind.each_with_index do |line, i|
    print "#{i} #{line.join}\n"
  end

  nil
end

def move_letter(pions, letter, to_coords)
  from_coords = pions[letter]
  pions[letter] = to_coords

  steps_count = 0
  steps_count += (from_coords[0] - to_coords[0]).abs
  steps_count += (from_coords[1] - to_coords[1]).abs

  # Does not stop in the hallway
  if from_coords[1] != 1 && to_coords[1] != 1
    steps_count += 2
  end

  energy_used = steps_count*@steps_weight[letter[0]]
  # print "Energy used: #{energy_used}\n"

  [pions, energy_used]
end

def already_placed?(pions, name)
  reversed_pions = pions.dup.map(&:reverse).to_h
  letter = name[0]
  coords = pions[name]

  return false if hallway?(pions, name)
  return false if @final_col[letter] != coords[0]

  letters = (2..5).map do |i|
    name = reversed_pions[[coords[0], i]]

    if name
      name[0]
    else
      nil
    end
  end

  case coords[1]
  when 5
    true
  when 4
    letters.last == letter
  when 3
    letters.last(2).uniq == [letter]
  when 2
    letters.last(3).uniq == [letter]
  else
    raise 'oops'
  end
end

def hallway?(pions, name)
  pions[name][1] == 1
end

def intru_in_room?(pions, letter)
  reversed_pions = pions.dup.map(&:reverse).to_h
  x_letter = @final_col[letter]

  letters_in_room = (2..@bottom_y).map do |y|
    reversed_pions[[x_letter, y]]
  end.compact.map do |name|
    name[0]
  end

  return false if letters_in_room.empty?

  letters_in_room.uniq != [letter]
end

def blocked_in_hallway?(pions, name)
  to_x = @final_col[name[0]]
  from_x = pions[name][0]

  if to_x > from_x
    range = (from_x..to_x)
  else
    range = (to_x..from_x)
  end

  range.any? do |x|
    pions.values.include?([x,1]) &&
      [x,1] != pions[name]
  end
end

def can_move_from_room?(pions, name)
  reversed_pions = pions.dup.map(&:reverse).to_h

  pion_x = pions[name][0]
  pion_y = pions[name][1]

  border_l_coords = [pion_x-1, 1]
  border_r_coords = [pion_x+1, 1]

  pion_in_l_border = reversed_pions.include?(border_l_coords)
  pion_in_r_border = reversed_pions.include?(border_r_coords)

  can_move_in_border = !pion_in_l_border || !pion_in_r_border

  return false unless can_move_in_border

  case pion_y
  when 2
    true
  when 3
    !pions.values.include?([pion_x, 2])
  when 4
    !pions.values.include?([pion_x, 2]) &&
      !pions.values.include?([pion_x, 3])
  when 5
    !pions.values.include?([pion_x, 2]) &&
      !pions.values.include?([pion_x, 3]) &&
      !pions.values.include?([pion_x, 4])
  end
end

def extract_directions_to_hallway(pions, name)
  pion_x = pions[name][0]
  coords = []
  room_enter_xs = [3,5,7,9]

  i = 1
  loop do
    nx = pion_x-i

    break if pions.values.include?([nx, 1])
    break if nx == 0

    coords << [nx, 1] unless room_enter_xs.include?(nx)

    i += 1
  end

  i = 1
  loop do
    nx = pion_x+i

    break if pions.values.include?([nx, 1])
    break if nx == 12

    coords << [nx, 1] unless room_enter_xs.include?(nx)

    i += 1
  end

  coords
end

def extract_direction_to_room(pions, name)
  reversed_pions = pions.dup.map(&:reverse).to_h
  x = @final_col[name[0]]

  (2..@bottom_y).to_a.reverse.each do |y|
    return [x, y] if reversed_pions[[x,y]].nil?
  end

  raise 'Not found'
end

def authorized_moves(pions, name)
  if already_placed?(pions, name)
    []
  elsif hallway?(pions, name)
    if blocked_in_hallway?(pions, name)
      []
    elsif intru_in_room?(pions, name[0])
      []
    else
      [extract_direction_to_room(pions, name)]
    end
  elsif can_move_from_room?(pions, name)
    extract_directions_to_hallway(pions, name)
  else
    []
  end
end

def win?(pions)
  pions.all? do |l, coords|
    if l[0] == 'a'
      coords[0] == 3
    elsif l[0] == 'b'
      coords[0] == 5
    elsif l[0] == 'c'
      coords[0] == 7
    elsif l[0] == 'd'
      coords[0] == 9
    end
  end
end

@best_score = Float::INFINITY
@max_depth = 0
@cache = []

# print_grid(pions)
# exit

def solve(pions, score, depth=0, i=0)
  return if @cache.include?(pions)

  # if i == 0 && depth == 172
  #   print_grid(pions)
  #   p score
  #   # p "Cache size: #{@cache.size}"
  #   # byebug if depth >= 1710
  # end

  if depth > @max_depth
    @max_depth = depth
    print "Max depth: #{@max_depth}\n"
  end

  if win?(pions)
    if score < @best_score
      print "New best score: #{score}\n"
      @best_score = score.dup
    end

    return
  end

  possible_outputs = []

  pions.each do |letter, coords|
    moves = authorized_moves(pions, letter)
    moves.each do |to_coords|
      pions_with_energy = move_letter(pions.dup, letter, to_coords)
      possible_outputs << pions_with_energy if pions_with_energy
    end
  end

  if possible_outputs.empty?
    @cache << pions
    # print "Cache size: #{@cache.length}\n"

    return
  end

  # byebug if depth >= 1710

  possible_outputs = possible_outputs.sort do |po1, po2|
    po1[1] <=> po2[1]
  end.reject do |possible_output|
    score + possible_output[1] > @best_score ||
      @cache.include?(possible_output[0])
  end

  # if depth > 500
  #   print "INITIAL\n"
  #   print_grid(pions)
  #
  #   possible_outputs.each do |possible_output|
  #     print_grid(possible_output[0])
  #     print "Energy: #{possible_output[1]}\n"
  #     print "=========\n"
  #   end
  #   print "=========================\n"
  #   exit
  # end

  possible_outputs.each_with_index do |possible_output, i|
    # byebug if depth >= 1710
    pions, energy = possible_output

    solve(pions, score + energy, depth+1, i)
  end
end

solve(pions, 0)

p @best_score
