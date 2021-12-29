# frozen_string_literal: true

require 'matrix'
require 'byebug'

data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
)

bingo = data.split("\n")[0].split(",").map { |i| i.to_i }
boards = []
board = []

data.split("\n")[2..].concat(['']).each do |line|
  if line.strip.empty?
    boards << Matrix[*board]
    board = []
  else
    board << line.split.map { |l| l.strip.to_i }
  end
end
mark_boards = []

boards.count.times do
  mark_boards << Matrix.zero(5)
end

def mark_board(number, board, mark_board)
  5.times do |i|
    5.times do |j|
      if board[i,j] == number
        mark_board[i,j] = 1
      end
    end
  end

  mark_board
end

def winning_board?(mark_board)
  mark_board.to_a.any? { |row| row.sum == 5 } ||
    mark_board.transpose.to_a.any? { |line| line.sum == 5 }
end

winning_board = nil
current_bingo = nil

bingo.each do |number|
  current_bingo = number
  boards.each_with_index do |b, i|
    mark_boards[i] = mark_board(number, b, mark_boards[i])
  end

  mark_boards.each_with_index do |mb, i|
    if winning_board?(mb)
      winning_board = boards[i]
      break
    end
  end

  break if winning_board
end

sum_winning_board = 0
mark_winning_board = mark_boards[boards.index(winning_board)]

5.times do |i|
  5.times do |j|
    if mark_winning_board[i,j] == 0
      sum_winning_board += winning_board[i,j]
    end
  end
end

print current_bingo*sum_winning_board
