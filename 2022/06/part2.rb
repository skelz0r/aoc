data = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).strip

(data.length - 13).times do |i|
  chars = data[i..i+13].dup

  next unless chars.split('').uniq.count == 14

  p chars, i+14
  break
end
