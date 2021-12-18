# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Int
  attr_accessor :value, :ancestor

  def initialize(value, ancestor)
    @value = value.to_i
    @ancestor = ancestor
  end

  def +(other)
    @value += other.value
  end

  def to_s
    @value
  end

  def split
    a = (value.to_f / 2).floor
    b = (value.to_f / 2).ceil

    new_pair = SailfishNumber.new([a, b], @ancestor, @ancestor.depth + 1)

    if @ancestor.pair[0] == self
      @ancestor.pair[0] = new_pair
    else
      @ancestor.pair[1] = new_pair
    end
  end
end

class SailfishNumber
  attr_reader :ancestor, :pair, :depth

  def initialize(pair, ancestor = nil, depth = 0)
    parsed_pair = []
    @ancestor = ancestor
    @depth = depth

    if !pair[0].is_a?(Array) && !pair[1].is_a?(Array)
      @pair = pair.map { Int.new(_1, self) }
    else
      parsed_pair << (pair[0].is_a?(Array) ? SailfishNumber.new(pair[0], self, @depth + 1) : Int.new(pair[0], self))
      parsed_pair << (pair[1].is_a?(Array) ? SailfishNumber.new(pair[1], self, @depth + 1) : Int.new(pair[1], self))
      @pair = parsed_pair
    end
  end

  def simplify
    continue = true
    while continue
      if (to_process = children.flatten.select { _1.is_a?(SailfishNumber) && _1.depth >= 4 }[0])
        to_process.explode
        continue = true
      elsif (to_process = int_children.flatten.select { _1.is_a?(Int) && _1.value >= 10 }[0])
        to_process.split
        continue = true
      else
        continue = false
      end
    end
  end

  def explode
    flat_children = master_node.int_children.flatten
    idx = flat_children.index(@pair[0])


    flat_children[idx - 1] + @pair[0] if idx.positive?
    flat_children[idx + 2] + @pair[1] if idx < flat_children.count - 2

    if @ancestor.pair[0] == self
      @ancestor.pair[0] = Int.new(0, @ancestor)
    elsif @ancestor.pair[1] == self
      @ancestor.pair[1] = Int.new(0, @ancestor)
    end
  end

  def children
    if @pair.any? { _1.is_a? SailfishNumber }
      children = []
      children << (@pair[0].is_a?(SailfishNumber) ? @pair[0].children : @pair[0])
      children << (@pair[1].is_a?(SailfishNumber) ? @pair[1].children : @pair[1])
    else
      self
    end
  end

  def int_children
    children = []
    children << (@pair[0].is_a?(SailfishNumber) ? @pair[0].int_children : @pair[0])
    children << (@pair[1].is_a?(SailfishNumber) ? @pair[1].int_children : @pair[1])
  end

  def master_node
    @ancestor.nil? ? self : @ancestor.master_node
  end

  def ancestors
    ancestor.flat_map(&:ancestors)
  rescue NoMethodError
    []
  end

  def to_s
    "(#{@depth})#{@pair[0]};#{@pair[1]}"
  end

  def magnitude
    magnitude = 3 * (@pair[0].is_a?(SailfishNumber) ? @pair[0].magnitude : @pair[0].value)
    magnitude + 2 * (@pair[1].is_a?(SailfishNumber) ? @pair[1].magnitude : @pair[1].value)
  end

  def to_a
    array = []
    array << (@pair[0].is_a?(SailfishNumber) ? @pair[0].to_a : @pair[0].value)
    array << (@pair[1].is_a?(SailfishNumber) ? @pair[1].to_a : @pair[1].value)
    array
  end
end

class Puzzle
  attr_reader :data, :numbers, :number

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @numbers = @data.map { SailfishNumber.new(eval(_1)) }
  end

  def perform
    @number = @numbers.shift(1)[0]

    while (number = @numbers.shift(1)[0])
      @number = SailfishNumber.new([@number.to_a, number.to_a])
      @number.simplify
    end

    self
  end


  def to_s
    <<~OUTPUT
      Magnitude: #{@number.magnitude}
    OUTPUT
  end
end

puts Puzzle.new(file: '18/part-one/input.txt').perform
