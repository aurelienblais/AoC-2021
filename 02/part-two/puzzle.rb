# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :position, :depth, :aim

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content

    @position = 0
    @depth = 0
    @aim = 0
  end

  def perform
    @data.each do |row|
      action, units = row.split(' ')

      case action
      when 'forward'
        @position += units.to_i
        @depth += @aim * units.to_i
      when 'down'
        @aim += units.to_i
      else
        @aim -= units.to_i
      end
    end

    self
  end

  def to_s
    <<~OUTPUT
      Position: #{@position}
      Depth: #{@depth}
      Aim: #{@aim}
      Result: #{@position * @depth}
    OUTPUT
  end
end

puts Puzzle.new(file: '02/part-one/input.txt').perform
