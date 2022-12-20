require 'byebug'

file = ARGV[0].nil? ? 'input' : 'example'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n").map(&:to_i)

@data = @data.map.with_index do |value, index|
  [811589153*value, index]
end

@initial_pos = @data.dup

def dprint(string)
  # print string
end

dprint "Initial: #{@data.map { |d| d[0] }}\n"
10.times do
  @initial_pos.each do |data_pos|
    pos = data_pos[0]

    dprint "Move #{pos}\n"

    next if pos == 0

    initial_index = @data.index(data_pos)

    to_move = initial_index + pos
    to_move = to_move < 0 ? @data.length + to_move - 1 : to_move

    @data.delete(data_pos)

    if to_move == 0
      @data << data_pos
    else
      @data.insert(to_move % @data.length, data_pos)
    end

    dprint "Result: #{@data.map { |d| d[0] }}\n\n"
  end
end

@zero_index = @data.index do |datum|
  datum[0] == 0
end

def get_index(index)
  @data[(@zero_index + index) % @data.length][0]
end

print get_index(1000) + get_index(2000) + get_index(3000)
