# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Packet
  attr_reader :version, :type, :length_type, :length, :content, :parsed_value, :sub_packets, :byte_size

  def initialize(hex_value: nil, binary_value: nil)
    if hex_value
      @parsed_value = hex_value.split('').map{ _1.hex.to_s(2).rjust(4, "0") }.join.split('')
    else
      @parsed_value = binary_value
    end

    @version = @parsed_value.shift(3).join.to_i(2)
    @type = @parsed_value.shift(3).join.to_i(2)
    @byte_size = 6
    @sub_packets = []

    if @type == 4
      parse_litteral
    else
      parse_operator
    end

  end

  def to_a
    [self].concat(@sub_packets.map(&:to_a)).flatten
  end

  def to_s
    val = "Version: #{@version} Type: #{@type} Value: #{@content} Length: #{@length} Length Type: #{@length_type} Subpacket: #{@sub_packets.length} Byte size: #{@byte_size}\n"
    @sub_packets.each { val += _1.to_s }
    val
  end

  def process
    if @type == 4
      @content
    else
      case @type
        when 0
          @sub_packets.reduce(0) { |val, p| val + p.process }
        when 1
          @sub_packets.reduce(1) { |val, p| val * p.process }
        when 2
          @sub_packets.map(&:process).min
        when 3
          @sub_packets.map(&:process).max
        when 5
          @sub_packets[0].process > @sub_packets[1].process ? 1 : 0
        when 6
          @sub_packets[0].process < @sub_packets[1].process ? 1 : 0
        when 7
          @sub_packets[0].process == @sub_packets[1].process ? 1 : 0
        else
          raise "Not implemented #{@type}"
      end
    end
  end

  private

  def parse_litteral
    local_value = []
    while (byte = @parsed_value.shift(5))
      break if byte.empty?

      local_value << byte[1..]
      @byte_size += 5

      break if byte[0] == "0"
    end

    @content = local_value.join.to_i(2)
  end

  def parse_operator
    @length_type = @parsed_value.shift(1)[0].to_i
    @byte_size += 1
    return if @parsed_value.length.zero?

    @length = (@length_type.zero? ? @parsed_value.shift(15) : @parsed_value.shift(11)).join.to_i(2)
    @byte_size += @length_type.zero? ? 15 : 11
    return if @parsed_value.length.zero?

    read_values = 0

    while read_values != @length
      bits = read_subpacket
      read_values += @length_type.zero? ? bits : 1
      break if @parsed_value.length.zero?
    end
  end

  def read_subpacket
    sub_packet = Packet.new(binary_value: @parsed_value.dup)
    sub_packet = Packet.new(binary_value: @parsed_value.shift(sub_packet.byte_size))

    @byte_size += sub_packet.byte_size

    @sub_packets << sub_packet
    sub_packet.byte_size
  end
end

class Puzzle
  attr_reader :data, :packet


  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content[0]
  end

  def perform
    @packet = Packet.new(hex_value: @data)

    self
  end


  def to_s
    <<~OUTPUT
      Result : #{@packet.process}
    OUTPUT
  end
end

puts Puzzle.new(file: '16/part-one/input.txt').perform
