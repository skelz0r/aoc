# frozen_string_literal: true

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
  '8A004A801A8002F478' => 16,
  '620080001611562C8802118E34' => 12,
  'C0015000016115A2E0802F182340' => 23,
  'A0016C880162017C3686B18A3D4780' => 31,
}

def handle_literal_value
  init_pos = @i.dup

  loop do
    start_bit = @bits[@i]
    @i += 5

    if start_bit == '0'
      # byebug
      # @i += ((@i - init_pos) % 4 + 1)
      break
    end
  end
end

def handle_packet
  return if @bits[@i+5].nil?

  version = bits_to_int(@bits[@i..@i+2])
  type = bits_to_int(@bits[@i+3..@i+5])

  @version += version

  @i += 6

  if type == 4
    p "[#{@i}] Litteral value"
    p "Version: #{version}"
    handle_literal_value
  else
    length_type_id = @bits[@i]

    @i += 1

    if length_type_id == '0'
      total_bits_length = bits_to_int(@bits[@i..@i+14])
      p "[#{@i}] Total bits length: #{total_bits_length}"
      p "Version: #{version}"

      @i += 15

      pos_init = @i.dup

      while @i < pos_init + total_bits_length #&& !@bits[@i+5].nil?
        handle_packet
      end
    else
      # return if @bits[@i].nil?

      total_sub_packets = bits_to_int(@bits[@i..@i+10])
      p "[#{@i}] Total sub packets: #{total_sub_packets}"
      p "Version: #{version}"

      @i += 11

      total_sub_packets.times do
        handle_packet
      end
    end
  end
end

def compute(key, v=nil)
  @i = 0
  @version = 0
  @bits = hexa_to_bits(key)

  p "Example: #{key}"
  p "Bits (#{@bits.length}): #{@bits}"

  handle_packet

  p "Expected: #{v}" if v
  p "Result: #{@version}"
  p "==================="
end

@examples.each do |key, v|
  compute(key, v)
  # exit
end

compute(@hexa)
