crates_raw, instructions_raw = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n\n")

instructions = instructions_raw.split("\n").map do |line|
  words = line.split(' ')

  [words[1].to_i, words[3].to_i, words[5].to_i]
end

crates_count = crates_raw.split("\n")[-1].split(/\s+/)[-1].to_i
crates = crates_raw.split("\n")[0..-2].reverse.inject({}) do |acc, line|
  (1..crates_count).each do |i|
    acc[i] ||= []

    next if line[1+(i-1)*4] == ' '
    next if line[1+(i-1)*4].nil?

    acc[i] << line[1+(i-1)*4]
  end

  acc
end

instructions.each do |instruction|
  instruction[0].times do
    crates[instruction[2]] << crates[instruction[1]].pop
  end
end

top_stack = crates.values.map do |stack|
  stack[-1]
end

print top_stack.join
