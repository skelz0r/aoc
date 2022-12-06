data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).strip

(data.length - 3).times do |i|
  chars = data[i..i+3].dup

  next unless chars.split('').uniq.count == 4

  p chars, i+4
  break
end
