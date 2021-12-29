require 'byebug'

@hexa = File.read(
  File.join(
    File.dirname(__FILE__),
    './input.txt'
  )
)

def hexa_to_bits(hexa)
  hexa.split('').map do |h|
    {
      '0' => '0000',
      '1' => '0001',
      '2' => '0010',
      '3' => '0011',
      '4' => '0100',
      '5' => '0101',
      '6' => '0110',
      '7' => '0111',
      '8' => '1000',
      '9' => '1001',
      'A' => '1010',
      'B' => '1011',
      'C' => '1100',
      'D' => '1101',
      'E' => '1110',
      'F' => '1111',
    }[h]
  end.join('')
end

def bits_to_int(bits)
  bits.to_i(2)
rescue => e
  byebug
end

@examples = {
  'C200B40A82' => 3,
  '04005AC33890' => 54,
  '880086C3E88112' => 7,
  'CE00C43D881120' => 9,
  'D8005AC2A8F0' => 1,
  'F600BC2D8F' => 0,
  '9C005AC2F8F0' => 0,
  '9C0141080250320F1802104A08' => 1,
}

def handle_literal_value
  init_pos = @i.dup
  v = ''

  loop do
    start_bit = @bits[@i]
    v << @bits[@i+1..@i+4]
    @i += 5

    if start_bit == '0'
      break
    end
  end

  v.to_i(2)
end

def handle_operation(values, type)
  case type
  when 0
    values.reduce(:+)
  when 1
    values.reduce(:*)
  when 2
    values.min
  when 3
    values.max
  when 5
    values[0] > values[1] ? 1 : 0
  when 6
    values[1] > values[0] ? 1 : 0
  when 7
    values[0] == values[1] ? 1 : 0
  else
    raise 'Not valid'
  end
end

def handle_packet
  version = bits_to_int(@bits[@i..@i+2])
  type = bits_to_int(@bits[@i+3..@i+5])

  @i += 6

  if type == 4
    p "[#{@i}] Litteral value"

    handle_literal_value
  else
    packets = []
    length_type_id = @bits[@i]

    @i += 1

    if length_type_id == '0'
      total_bits_length = bits_to_int(@bits[@i..@i+14])
      p "[#{@i}] Total bits length: #{total_bits_length}"

      @i += 15

      pos_init = @i.dup

      while @i < pos_init + total_bits_length
        packets << handle_packet
      end
    else
      total_sub_packets = bits_to_int(@bits[@i..@i+10])
      p "[#{@i}] Total sub packets: #{total_sub_packets}"

      @i += 11

      total_sub_packets.times do
        packets << handle_packet
      end
    end

    handle_operation(packets, type)
  end
end

def compute(key, v=nil)
  @i = 0
  @bits = hexa_to_bits(key)

  p "Example: #{key}"
  p "Bits (#{@bits.length}): #{@bits}"

  result = handle_packet

  p "Expected: #{v}" if v
  p "Result: #{result}"
  p "==================="
end

@examples.each do |key, v|
  compute(key, v)
  # exit
end

compute(@hexa)
