# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :cost

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content[0].split(',').map(&:to_i)
    @cost = nil
  end

  def perform
    @data.length.times do |pos|
      cost = @data.sum { |i| (i - pos).abs }

      @cost = cost if @cost.nil? || cost < @cost
    end

    self
  end

  def to_s
    <<~OUTPUT
      Lowest cost: #{@cost}
    OUTPUT
  end
end

puts Puzzle.new(file: '07/part-one/input.txt').perform
