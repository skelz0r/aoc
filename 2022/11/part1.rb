require 'byebug'

monkeys = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
).split("\n\n").inject({}) do |acc, monkey_raw_data|
  monkey_data = monkey_raw_data.split("\n")

  monkey_number = monkey_data[0].split(' ')[1].to_i

  acc[monkey_number] = {
    starting_items: monkey_data[1].split(':')[1].split(',').map(&:to_i),
    operation: monkey_data[2].split(':')[1].strip.split(' = ')[-1],
    test_divisible: monkey_data[3].split(' ')[-1].to_i,
    true_throw_monkey: monkey_data[4].split(' ')[-1].to_i,
    false_throw_monkey: monkey_data[5].split(' ')[-1].to_i,
    inspected: 0,
  }

  acc
end

def dprint(string)
  # print string
end

def compute_operation(item, operation)
  old = item

  eval(operation)
end

20.times do |i|
  dprint "## Round #{i+1}:\n"
  monkeys.each do |monkey_number, monkey_data|
    dprint "# Monkey #{monkey_number}:\n"
    monkey_data[:starting_items].dup.each do |item|
      monkey_data[:inspected] += 1

      dprint "Monkey inspect #{item} and use operation #{monkey_data[:operation]}\n"
      new_item = compute_operation(item, monkey_data[:operation])
      new_item /= 3
      dprint "New item: #{new_item}\n"

      if new_item % monkey_data[:test_divisible] == 0
        dprint "Divisible by #{monkey_data[:test_divisible]}\n"
        dprint "Monkey #{monkey_number} throw #{new_item} to monkey #{monkey_data[:true_throw_monkey]}\n"
        monkeys[monkey_data[:true_throw_monkey]][:starting_items] << new_item
      else
        dprint "Not divisible by #{monkey_data[:test_divisible]}\n"
        dprint "Monkey #{monkey_number} throw #{new_item} to monkey #{monkey_data[:false_throw_monkey]}\n"
        monkeys[monkey_data[:false_throw_monkey]][:starting_items] << new_item
      end

      monkeys[monkey_number][:starting_items].delete(item)
      dprint "----\n"
    end
  end

  monkeys.each do |monkey_number, monkey_data|
    dprint "> Monkey #{monkey_number} has #{monkey_data[:starting_items]} items\n"
  end
end

dprint "##############\n"

monkeys.each do |monkey_number, monkey_data|
  dprint "Monkey #{monkey_number} inspected #{monkey_data[:inspected]} items\n"
end

print monkeys.map { |_, monkey_data| monkey_data[:inspected] }.max(2).reduce(:*)
