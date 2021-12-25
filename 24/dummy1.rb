# frozen_string_literal: true

require 'byebug'

file = 'input'
@should_debug = true

@instructions = File.read(
  File.join(
    File.dirname(__FILE__),
    "./#{file}.txt",
  )
).split("\n").reject do |line|
  line.size == 0
end

def debug(string)
  return unless @should_debug

  print string
  print "\n"
end

def var_or_value(vars, text)
  if vars.keys.include?(text)
    vars[text]
  else
    text.to_i
  end
end

def execute(instructions, initial_value, vars = nil)
  vars ||= {
    'w' => 0,
    'x' => 0,
    'y' => 0,
    'z' => 0,
  }
  value = initial_value.to_s.split('').map { |c| c.to_i }.reverse

  instructions.each do |instruction|
    kind, *elements = instruction.split(" ")

    begin
    case kind
    when 'inp'
      value_to_affect = value.pop
      vars[elements[0]] = value_to_affect
    when 'add'
      vars[elements[0]] += var_or_value(vars, elements[1])
    when 'mul'
      vars[elements[0]] *= var_or_value(vars, elements[1])
    when 'div'
      vars[elements[0]] = vars[elements[0]] / var_or_value(vars, elements[1])
    when 'mod'
      vars[elements[0]] = vars[elements[0]] % var_or_value(vars, elements[1])
    when 'eql'
      vars[elements[0]] = vars[elements[0]] == var_or_value(vars, elements[1]) ? 1 : 0
    end
    rescue
      byebug
    end
  end

  vars
end

value = 49_999_999_999_999
@minz = Float::INFINITY

interesting_values = [
  99992996943286, # 613
  99992979946998, # 414788
]

step_size = 1
i = 0

byebug

exit
nb_threads = 3
threads = []

nb_threads.times do |i|
  threads << Thread.new do
    loop do
      value -= step_size

      next if value.to_s.include?('0')

      i += 1

      vars = execute(@instructions, value)

      if vars['z'] < @minz
        @minz = vars['z']
        p "New min: #{@minz}"
      end

      if vars['z'] == 0
        @minz = vars['z']

        p "WIN: #{value}"
        exit
      end

      # if i % 100_000 == 0
      #   p "Current status: #{value}\n"
      # end
    end
  end
end

nb_threads.each(&:join)
