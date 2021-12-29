# frozen_string_literal: true

@all_possible_values =  [1, 2, 3].repeated_permutation(3).map(&:sum).tally
@cache = {}

def dirac(p1_turn, p1p, p2p, p1s = 0, p2s = 0)
  cache_key = [p1_turn, p1p, p2p, p1s, p2s]
  return @cache[cache_key] if @cache.key?(cache_key)

  return [1,0] if p1s >= 21
  return [0,1] if p2s >= 21

  result = [0,0]

  if p1_turn
    @all_possible_values.each do |value, count|
      p1p_alt = (p1p + value) % 10
      p1p_alt = p1p_alt == 0 ? 10 : p1p_alt
      p1s_alt = p1s + p1p_alt

      alt_r = dirac(false, p1p_alt, p2p, p1s_alt, p2s)

      result[0] += alt_r[0]*count
      result[1] += alt_r[1]*count
    end
  else
    @all_possible_values.each do |value, count|
      p2p_alt = (p2p + value) % 10
      p2p_alt = p2p_alt == 0 ? 10 : p2p_alt
      p2s_alt = p2s + p2p_alt

      alt_r = dirac(true, p1p, p2p_alt, p1s, p2s_alt)

      result[0] += alt_r[0]*count
      result[1] += alt_r[1]*count
    end
  end

  @cache[cache_key] = result

  result
end

p1p=3
p2p=7

# p1p=4
# p2p=8

p dirac(true, p1p, p2p)
