require 'byebug'

file = ARGV[0].nil? ? 'input' : 'example'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n")

@monkeys = @data.inject({}) do |acc, line|
  monkey_name, data = line.split(': ')

  if data =~ /\d+/
    operation = 'none'
    value = data.to_i

    acc[monkey_name] = {
      operation: operation,
      value: value,
    }
  else
    m1, operation, m2 = data.split(' ')
    acc[monkey_name] = {
      operation: operation,
      m1: m1,
      m2: m2,
    }
  end

  acc
end

def yell(monkey_name)
  monkey = @monkeys[monkey_name]

  return monkey[:value] if monkey[:operation] == 'none'

  m1 = monkey[:m1]
  m2 = monkey[:m2]

  case monkey[:operation]
  when '+'
    yell(m1) + yell(m2)
  when '-'
    yell(m1) - yell(m2)
  when '/'
    yell(m1) / yell(m2)
  when '*'
    yell(m1) * yell(m2)
  end
end

print yell('root')
