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

@valves = {}

@data.each do |line|
  p1,p2 = line.split(';')
  valve = p1.split[1]
  rate = p1.split('=')[1].to_i
  valves = p2.split(',')
  valves[0] = valves[0].split(' ')[-1]

  @valves[valve] = {
    rate: rate,
    lead_to: valves.map { |v| [v.strip,1] },
  }
end

@tab = ' '
@best_outcome = 0

def loop_detected?(paths)
  paths.length > 5 &&
    paths[-4..-3] == paths[-2..-1]
end

def max_possible_outcome(remaining, acc, opened_valves)
  remaining_valve_keys = @valves.keys - opened_valves

  sorted_rates = remaining_valve_keys.inject([]) do |acc, valve_key|
    acc << @valves[valve_key][:rate] if @valves[valve_key][:rate] > 0
    acc
  end.sort.reverse
  # p acc, sorted_rates

  i = 0
  acc + sorted_rates.reduce(0) do |sum, rate|
    i += 1
    sum + rate*(remaining - i)
  end
end

def tick(valve_key, remaining, acc, opened_valves=[], paths=[])
  dprint "tick(#{valve_key}, #{remaining}, #{acc}, #{opened_valves})\n"
  # byebug
  valve = @valves[valve_key]
  step_tick = false

  if remaining == 0 #|| opened_valves.count == @valves.keys.count
    if acc > @best_outcome
      @best_outcome = acc
      print "Path: #{paths.join('->')}\n"
      print "New best outcome: #{acc}\n"
    end
    return
  end

  if loop_detected?(paths)
    dprint "loop detected, skipping\n"
    return
  end

  if @best_outcome > max_possible_outcome(remaining.dup, acc.dup, opened_valves.dup)
    dprint "impossible to reach a better outcome, skipping\n"
    return
  end

  if valve[:rate] != 0 && !opened_valves.include?(valve_key)
    dprint "#{@tab*(30-remaining)}Opening valve #{valve_key}\n"
    # byebug
    tick(valve_key, remaining-1, (acc + (remaining-1) * valve[:rate]), (opened_valves.dup << valve_key).uniq, (paths.dup << valve_key))
    step_tick = true
  end

  valve[:lead_to].each do |target_valve_data|
    tick(target_valve_data[0], remaining-target_valve_data[1], acc, opened_valves, (paths.dup << valve_key))
    step_tick = true
  end

  return if step_tick

  # No move was made, we are stuck -> go to end
  tick(valve_key, 0, acc, opened_valves, paths.dup)
end

tick('AA', 30, 0)
