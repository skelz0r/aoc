require 'byebug'

file = ARGV[0].nil? ? 'input' : 'example'

@moves = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n")[0].split('')

def dprint(string)
  # print string
end

def draw_current_tetris
  @game.each do |row|
    dprint "|" + row.join('') + "|\n"
  end
  dprint "+-------+\n\n"
end

@rocks = [
  [
    ['.','.','@','@','@','@','.']
  ],
  [
    ['.','.','.','@','.','.','.'],
    ['.','.','@','@','@','.','.'],
    ['.','.','.','@','.','.','.'],
  ],
  [
    ['.','.','.','.','@','.','.'],
    ['.','.','.','.','@','.','.'],
    ['.','.','@','@','@','.','.'],
  ],
  [
    ['.','.','@','.','.','.','.'],
    ['.','.','@','.','.','.','.'],
    ['.','.','@','.','.','.','.'],
    ['.','.','@','.','.','.','.'],
  ],
  [
    ['.','.','@','@','.','.','.'],
    ['.','.','@','@','.','.','.'],
  ]
]

@game = [
  ['.'] * 7,
]*4
@rocks_count = 0
@rock_moving = false
@current_move = nil
@empty_line = ['.'] * 7
@top_rock_index = 0

def current_highest_rock_row
  @game.each_with_index do |row, index|
    return index if row.include?('#')
  end

  return @game.length
end

def max_current_rock_height
  case (@rocks_count % 5) - 1
  when 0
    1
  when 1
    3
  when 2
    3
  when 3
    4
  when -1
    2
  end
end

def can_move?(position)
  h = 0
  @game.each do |row|
    break if h == max_current_rock_height
    h += 1 if row.include?('@')

    row.each_with_index do |cell, index|
      return false if cell == '@' && (
        (position == :right && (index == 6 || row[index+1] == '#')) ||
        (position == :left && (index == 0 || row[index-1] == '#'))
      )
    end
  end

  true
end

def can_drop?
  @game.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next unless cell == '@'

      return false if y == @game.length-1 || @game[y+1][x] == '#'
    end
  end

  true
end

def drop_rock!
  dprint "## Drop rock\n"

  max_current_rock_height.times do |iy|
    row = @game[(@top_rock_index + max_current_rock_height - 1) - iy]

    row.each_with_index do |cell, x|
      if cell == '@'
        row[x] = '.'
        @game[(@top_rock_index + max_current_rock_height - 1) - iy + 1][x] = '@'
      end
    end
  end

  @top_rock_index += 1
end

def move(position)
  dprint "## Move to the #{position}\n"
  skip_next = false

  @game[@top_rock_index..@top_rock_index+max_current_rock_height].each do |row|
    row.length.times do |index|
      if position == :right
        to_move_index = row.length - index - 1
        next unless row[to_move_index] == '@'

        row[to_move_index] = '.'
        row[to_move_index + 1] = '@'
      else
        to_move_index = index
        next unless row[to_move_index] == '@'

        row[to_move_index] = '.'
        row[to_move_index - 1] = '@'
      end
    end
  end
end

def rest_rock!
  dprint "# Rest rock\n"

  @game[@top_rock_index..@top_rock_index+max_current_rock_height].each do |row|
    row.each_with_index do |cell, index|
      row[index] = '#' if cell == '@'
    end
  end
end

loop do
  unless @rock_moving
    print "# New rock #{@rocks_count+1}\n"
    rock = @rocks[@rocks_count % @rocks.count].dup.map(&:dup)
    @rocks_count += 1

    highest_rock_row = current_highest_rock_row

    @game.shift(highest_rock_row)
    3.times do
      @game.unshift(@empty_line.dup)
    end
    @game.unshift(*rock.dup)

    @rock_moving = true
    @current_move = :push
    @top_rock_index = 0
  end

  break if @rocks_count == 2022+1

  if @current_move == :push
    next_push = @moves.shift
    @moves << next_push

    dprint "# Push rock #{next_push}\n"

    move(:right) if next_push == '>' && can_move?(:right)
    move(:left) if next_push == '<' && can_move?(:left)

    @current_move = :drop
  else
    if can_drop?
      drop_rock!
    else
      rest_rock!

      @rock_moving = false

      draw_current_tetris
    end

    @current_move = :push
  end
end

@game.each_with_index do |row, index|
  if row.include?('#')
    print @game.length-index
    break
  end
end
