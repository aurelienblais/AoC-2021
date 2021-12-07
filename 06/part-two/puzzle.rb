# frozen_string_literal: true

require_relative '../../commons/input_reader'
require_relative '../../commons/vector'

class Puzzle
  attr_reader :data, :fish

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @fish = @data[0].split(',').map(&:to_i).group_by{ _1 }.transform_values(&:count)
  end

  def perform
    256.times do |day|
      @fish[7] ||= 0
      @fish[7] += @fish[0] if @fish[0]

      @fish[9] ||= 0
      @fish[9] += @fish[0] if @fish[0]

      @fish.transform_keys! { _1 - 1 }
      @fish.delete(-1)
    end

    self
  end

  def to_s
    <<~OUTPUT
      Fish count : #{@fish.values.sum}
    OUTPUT
  end
end

puts Puzzle.new(file: '06/part-one/input.txt').perform
