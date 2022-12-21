require 'byebug'

file = ARGV[0].nil? ? 'input' : 'example'

@data = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt"
  )
).split("\n")

def dprint(string)
  # print string
end

@monkeys = @data.inject({}) do |acc, line|
  monkey_name, data = line.split(': ')

  if monkey_name == 'humn'
    acc[monkey_name] = {
      operation: 'none',
      value: '[x]',
    }
  else
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
        operation: monkey_name == 'root' ? '=' : operation,
        m1: m1,
        m2: m2,
      }
    end
  end

  acc
end

def result_or_expand(value)
  expand_yell(value).include?('[x]') ? expand_yell(value) : yell(value)
end

def expand_yell(monkey_name)
  monkey = @monkeys[monkey_name]

  if monkey_name == 'humn'
    return '[x]'
  end

  return monkey[:value].to_s if monkey[:operation] == 'none'

  m1 = monkey[:m1]
  m2 = monkey[:m2]

  if monkey[:operation] == '='
    "(#{result_or_expand(m1)} = #{result_or_expand(m2)})"
  else
    "(#{result_or_expand(m1)}#{monkey[:operation]}#{result_or_expand(m2)})"
  end
end

def dummy_expand_yell(monkey_name)
  monkey = @monkeys[monkey_name]

  if monkey_name == 'humn'
    return '[x]'
  end

  return monkey[:value].to_s if monkey[:operation] == 'none'

  m1 = monkey[:m1]
  m2 = monkey[:m2]

  if monkey[:operation] == '='
    "#{dummy_expand_yell(m1)} = #{dummy_expand_yell(m2)}"
  else
    "(#{dummy_expand_yell(m1)}#{monkey[:operation]}#{dummy_expand_yell(m2)})"
  end
end

loop do
  operation_done = false

  @monkeys.each do |monkey_name, data|
    operation = data[:operation]

    next if operation == 'none'
    next if @monkeys[data[:m1]][:value] == '[x]' || @monkeys[data[:m2]][:value] == '[x]'

    if @monkeys[data[:m1]][:operation] == 'none' && @monkeys[data[:m2]][:operation] == 'none'
      @monkeys[monkey_name][:value] = eval("#{@monkeys[data[:m1]][:value]} #{operation} #{@monkeys[data[:m2]][:value]}")
      @monkeys[monkey_name][:operation] = 'none'

      operation_done = true
    end
  end

  break unless operation_done

  dprint "Operation occured\n"
end

dprint "Operations done\n"

@acc = []

def expand_rpn(monkey_name)
  monkey = @monkeys[monkey_name]

  if monkey[:operation] == 'none'
    if monkey[:value] == '[x]'
      return 'x'
    else
      return monkey[:value]
    end
  end

  [expand_rpn(monkey[:m1]), expand_rpn(monkey[:m2]), monkey[:operation]]
end

print dummy_expand_yell('root')
print "\n"
rpn = expand_rpn('root')

result = rpn[-2]
to_reduce = rpn[0]

while to_reduce.length != 1
  operation = to_reduce.pop

  if to_reduce[1].is_a?(Array)
    value_position = :left
    value = to_reduce.shift
  else
    value_position = :right
    value = to_reduce.pop
  end

  to_reduce = to_reduce[0]

  dprint "Reducing #{value} with #{operation}\n"

  case operation
  when '+'
    result -= value
  when '-'
    if value_position == :left
      result -= value
      result *= -1
    else
      result += value
    end
  when '*'
    result /= value
  when '/'
    result *= value
  end
end

print result
